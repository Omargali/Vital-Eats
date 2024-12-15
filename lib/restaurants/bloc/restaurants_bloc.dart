import 'dart:async';

import 'package:api/client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'restaurants_bloc_mixin.dart';
part 'restaurants_event.dart';
part 'restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState>
    with RestaurantsBlocMixin {
  RestaurantsBloc({
    required RestaurantsRepository restaurantsRepository,
    required UserRepository userRepository,
  })  : _restaurantsRepository = restaurantsRepository,
        _userRepository = userRepository,
        super(const RestaurantsState.initial()) {
    on<RestaurantsFetchRequested>(_onFetchRequested);
    on<RestaurantsLocationChanged>(_onRestaurantsLocationChanged);
    on<RestaurantsRefreshRequested>(_onRefreshRequested);

    _locationSubscription = _userRepository
        .currentLocation()
        .listen(_onLocationChanged, onError: addError);
  }

  final RestaurantsRepository _restaurantsRepository;
  final UserRepository _userRepository;

  StreamSubscription<Location>? _locationSubscription;

  @override
  RestaurantsRepository get restaurantsRepository => _restaurantsRepository;

  void _onLocationChanged(Location location) =>
      add(RestaurantsLocationChanged(location));

  void _onRestaurantsLocationChanged(
    RestaurantsLocationChanged event,
    Emitter<RestaurantsState> emit,
  ) {
    final location = event.location;
    if (state.location == location) return;
    if (location.isUnderfined) return;

    emit(state.copyWith(location: location));
    add(const RestaurantsFetchRequested());
  }

  Future<void> _onFetchRequested(
    RestaurantsFetchRequested event,
    Emitter<RestaurantsState> emit,
  ) async {
    final currentPage = event.page ?? state.restaurantsPage.page;
    emit(
      state.copyWith(
        status: currentPage == 0 ? RestaurantsStatus.loading : null,
      ),
    );
    try {
      final (:newPage, :hasMore, :restaurants) = await fetchRestaurantsPage(
        page: currentPage,
      );
      final filteredRestaurants = _fillterRestaurants(restaurants);
      emit(
        state.copyWith(
          status: RestaurantsStatus.populated,
          restaurantsPage: state.restaurantsPage.copyWith(
            restaurants: [
              ...state.restaurantsPage.restaurants, 
              ...filteredRestaurants
              ],
            hasMore: hasMore,
            page: newPage,
            totalRestaurants:
                state.restaurantsPage.totalRestaurants + restaurants.length,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
  }
  
  Future<void> _onRefreshRequested(
     RestaurantsRefreshRequested event,
     Emitter<RestaurantsState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantsStatus.loading));
     try {
      final (:newPage, :hasMore, :restaurants) = await fetchRestaurantsPage();
      final filteredRestaurants = _fillterRestaurants(restaurants);
      emit(
        state.copyWith(
           status: RestaurantsStatus.populated,
          restaurantsPage: RestaurantsPage(
            page: newPage,
            restaurants: filteredRestaurants,
            hasMore: hasMore,
            totalRestaurants: filteredRestaurants.length,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  List<Restaurant> _fillterRestaurants(List<Restaurant> restaurants) {
    return restaurants
      ..whereMoveToTheFront((restaurant) {
        if(restaurant.rating == null) return false;
        final rating = restaurant.rating as double;
        return rating >= 4.8 || restaurant.userRatingsTotal >= 300;
      })
      ..whereMoveToTheEnd((restaurant) {
        if (restaurant.rating == null) return true;
        final rating = restaurant.rating as double;
        return rating >= 4.5 || restaurant.userRatingsTotal <= 100;
      });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
