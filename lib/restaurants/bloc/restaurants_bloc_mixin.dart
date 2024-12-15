part of 'restaurants_bloc.dart';

typedef PaginatedRestaurantsResults 
  = Future<({int newPage, bool hasMore, List<Restaurant> restaurants})>;

mixin RestaurantsBlocMixin on Bloc<RestaurantsEvent, RestaurantsState>{
  int get pageLimit => 4;

  RestaurantsRepository get restaurantsRepository;

  PaginatedRestaurantsResults fetchRestaurantsPage({
    int page = 0,
    }) async {
    final currentPage = page;
    final restaurants = await restaurantsRepository.getRestaurants(
      location: state.location,
      limit: pageLimit,
      offset: pageLimit * currentPage,
    );
    final newPage = currentPage + 1;
    final hasMore = restaurants.length >= pageLimit;

    return (newPage: newPage, hasMore: hasMore, restaurants: restaurants);
  }
}
