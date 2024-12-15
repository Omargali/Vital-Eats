
part of 'restaurants_bloc.dart';

enum RestaurantsStatus{
  initial,
  loading,
  populated,
  failure;

  bool get isLoading => this == loading;
  bool get isPopulated => this == populated;
  bool get isFailure => this == failure;
}

class RestaurantsState extends Equatable {
  const RestaurantsState._(
    {
    required this.status, 
    required this.restaurantsPage,
    required this.location,
    });

  const RestaurantsState.initial() 
      : this._(
        status: RestaurantsStatus.initial, 
        restaurantsPage: const RestaurantsPage.empty(),
        location: const Location.undefined(),
        );

  final RestaurantsStatus status;
  final RestaurantsPage restaurantsPage;
  final Location location;
  
  @override
  List<Object?> get props => [status, restaurantsPage];

  RestaurantsState copyWith({
    RestaurantsStatus? status,
    RestaurantsPage? restaurantsPage,
    Location? location,
  }) {
    return RestaurantsState._(
      status: status ?? this.status,
      restaurantsPage: restaurantsPage ?? this.restaurantsPage,
      location: location ?? this.location,
    );
  }
}
