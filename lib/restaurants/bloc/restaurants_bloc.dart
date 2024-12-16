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
    on<RestaurantsFilterTagChanged>(_onFilterTagChanged);
    on<_RestaurantsFilterTadAdded>(_onFilterTagAdded);
    on<_RestaurantsFilterTagRemoved>(_onFilterTagRemoved);
    on<RestaurantsFilterTagsClearRequested>(_onFilterTagsClear);
    on<RestaurantsFilterTagsChanged>(_onFilterTagsChanged);

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

    emit(
      state.copyWith(
        location: location,
        filteredRestaurants: [],
        chosenTags: [],
      ),
    );
    add(const RestaurantsRefreshRequested());
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
      final tags = currentPage == 0
          ? await _restaurantsRepository.getTags(location: state.location)
          : null;
      final filteredRestaurants = _fillterRestaurants(restaurants);
      emit(
        state.copyWith(
          tags: tags,
          status: RestaurantsStatus.populated,
          restaurantsPage: state.restaurantsPage.copyWith(
            restaurants: [
              ...state.restaurantsPage.restaurants,
              ...filteredRestaurants,
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
      final tags =
          await _restaurantsRepository.getTags(location: state.location);
      final filteredRestaurants = _fillterRestaurants(restaurants);
      emit(
        state.copyWith(
          status: RestaurantsStatus.populated,
          tags: tags,
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

  Future<void> _onFilterTagsClear(
    RestaurantsFilterTagsClearRequested event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantsStatus.loading));
    await Future<void>.delayed(const Duration(seconds: 1)).whenComplete(
      () => emit(
        state.copyWith(
          filteredRestaurants: [],
          chosenTags: [],
          status: RestaurantsStatus.populated,
        ),
      ),
    );
  }

   void _onFilterTagChanged(
    RestaurantsFilterTagChanged event,
    Emitter<RestaurantsState> emit,
  ) {
    final tag = event.tag;
    !state.chosenTags.contains(tag)
        ? add(_RestaurantsFilterTadAdded(tag))
        : add(_RestaurantsFilterTagRemoved(tag));
  }

  Future<void> _onFilterTagsChanged(
    RestaurantsFilterTagsChanged event,
    Emitter<RestaurantsState> emit,
  ) async {
    final tags = event.tags ?? state.chosenTags;
    emit(
      state.copyWith(
        status: RestaurantsStatus.loading,
        chosenTags: tags,
      ),
    );

    if (tags.isEmpty) {
      return add(const RestaurantsFilterTagsClearRequested());
    }

    try {
      final restaurants = await _restaurantsRepository.getRestaurantsByTags(
        tags: tags.map((e) => e.name).toList(),
        location: state.location,
      );
      final filteredRestaurants = _fillterRestaurants(restaurants);
      emit(
        state.copyWith(
          filteredRestaurants: filteredRestaurants,
          status: RestaurantsStatus.filtered,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onFilterTagAdded(
    _RestaurantsFilterTadAdded event,
    Emitter<RestaurantsState> emit,
  ) {
    final tag = event.tag;
    emit(
      state.copyWith(
        status: RestaurantsStatus.loading,
        chosenTags: [...state.chosenTags, tag],
      ),
    );
    add(const RestaurantsFilterTagsChanged());
  }

  void _onFilterTagRemoved(
    _RestaurantsFilterTagRemoved event,
    Emitter<RestaurantsState> emit,
  ) {
    final tag = event.tag;
    emit(
      state.copyWith(
        chosenTags: [...state.chosenTags]..remove(tag),
      ),
    );
    add(const RestaurantsFilterTagsChanged());
  }

  List<Restaurant> _fillterRestaurants(List<Restaurant> restaurants) {
    return restaurants
      ..whereMoveToTheFront((restaurant) {
        if (restaurant.rating == null) return false;
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
