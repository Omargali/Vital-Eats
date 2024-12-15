import 'package:api/client.dart';

/// {@template restaurants_exception}
/// Exceptions from restaurants repository.
/// {@endtemplate}
abstract class RestaurantsException implements Exception {
  /// {@macro restaurants_exception}
  const RestaurantsException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Restaurants exception error: $error';
}

/// {@template get_restaurants_by_location_failure}
/// Thrown when fetching restaurants by location fails.
/// {@endtemplate}
class GetRestaurantsByLocationFailure extends RestaurantsException {
  /// {@macro get_restaurants_by_location_failure}
  const GetRestaurantsByLocationFailure(super.error);
}

/// {@template restaurants_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class RestaurantsRepository {
  /// {@macro restaurants_repository}
  const RestaurantsRepository({
    required YandexEatsClient apiClient,
  }) : _apiClient = apiClient;

  final YandexEatsClient _apiClient;

   Future<List<Restaurant>> getRestaurants({
    required Location location,
    int? limit,
    int? offset,
  }) async {
    try {
      return _apiClient.getRestaurants(
        location: location,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetRestaurantsByLocationFailure(error),
        stackTrace,
      );
    }
  }
}
