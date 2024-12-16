import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_eats_2/restaurants/restaurants.dart';


class FilteredRestaurantsListView extends StatelessWidget {
  const FilteredRestaurantsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = context
        .select((RestaurantsBloc bloc) => bloc.state.filteredRestaurants);

    return RestaurantsListView(restaurants: filteredRestaurants);
  }
}
