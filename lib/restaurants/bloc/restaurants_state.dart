
part of 'restaurants_bloc.dart';

enum RestaurantsStatus{
  initial,
  loading,
  populated,
  filtered,
  failure;

  bool get isLoading => this == loading;
  bool get isPopulated => this == populated;
  bool get isFiltered => this == filtered;
  bool get isFailure => this == failure;
}

class RestaurantsState extends Equatable {
  const RestaurantsState._(
    {
    required this.status, 
    required this.restaurantsPage,
    required this.tags,
    required this.chosenTags,
    required this.filteredRestaurants,
    required this.location,
    });

  const RestaurantsState.initial() 
      : this._(
        status: RestaurantsStatus.initial, 
        restaurantsPage: const RestaurantsPage.empty(),
        tags: const [],
        chosenTags: const [],
        filteredRestaurants: const [],
        location: const Location.undefined(),
        );

  final RestaurantsStatus status;
  final RestaurantsPage restaurantsPage;
  final List<Tag> tags;
  final List<Tag> chosenTags;
  final List<Restaurant> filteredRestaurants;
  final Location location;
  
  @override
  List<Object?> get props => [status, restaurantsPage, tags, chosenTags, filteredRestaurants, location];

  RestaurantsState copyWith({
    RestaurantsStatus? status,
    RestaurantsPage? restaurantsPage,
    List<Tag>? tags,
    List<Tag>? chosenTags,
    List<Restaurant>? filteredRestaurants,
    Location? location,
  }) {
    return RestaurantsState._(
      status: status ?? this.status,
      restaurantsPage: restaurantsPage ?? this.restaurantsPage,
      tags: tags ?? this.tags,
      chosenTags: chosenTags ?? this.chosenTags,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      location: location ?? this.location,
    );
  }
}
