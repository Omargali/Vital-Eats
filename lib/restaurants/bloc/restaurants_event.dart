part of 'restaurants_bloc.dart';

sealed class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object?> get props => [];
}

final class RestaurantsFetchRequested extends RestaurantsEvent {
  const RestaurantsFetchRequested({this.page});

  final int? page;

  @override
  List<Object?> get props => [page];
}

final class RestaurantsLocationChanged extends RestaurantsEvent {
   const RestaurantsLocationChanged(this.location);

   final Location location;

   @override
  List<Object?> get props => [location];
}

final class RestaurantsRefreshRequested extends RestaurantsEvent {
  const RestaurantsRefreshRequested();
}
