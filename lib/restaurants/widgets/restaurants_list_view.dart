import 'package:api/client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_eats_2/network_error/network_error.dart';
import 'package:vital_eats_2/restaurants/restaurants.dart';

class RestaurantsListView extends StatelessWidget {
  const RestaurantsListView({super.key, this.restaurants = const []});

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    final restaurantsPage =
        context.select((RestaurantsBloc bloc) => bloc.state.restaurantsPage);
    final isFailure =
        context.select((RestaurantsBloc bloc) => bloc.state.status.isFailure);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: restaurants.isEmpty
          ? SliverList.builder(
              itemBuilder: (context, index) {
                final totalRestaurants = restaurantsPage.totalRestaurants;
                final hasMoreRestaurants = restaurantsPage.hasMore;
                final restaurants = restaurantsPage.restaurants;
                final restaurant = restaurants[index];

                return _buildItem(
                  context: context,
                  index: index,
                  totalRestaurants: totalRestaurants,
                  hasMoreRestaurants: hasMoreRestaurants,
                  isFailure: isFailure,
                  restaurant: restaurant,
                );
              },
              itemCount: restaurantsPage.restaurants.length,
            )
          : SliverList.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final openNow = restaurant.openNow;

                final card = RestaurantCard(
                  key: ValueKey(restaurant.placeId),
                  restaurant: restaurant,
                );
                if (openNow) return card;
                return Opacity(opacity: .6, child: card);
              },
            ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required int totalRestaurants,
    required bool hasMoreRestaurants,
    required bool isFailure,
    required Restaurant restaurant,
  }) {
    if (index + 1 == totalRestaurants && hasMoreRestaurants) {
      if (isFailure) {
        if (!hasMoreRestaurants) return const SizedBox.shrink();
        return NetworkError(
          onRetry: () => context
              .read<RestaurantsBloc>()
              .add(const RestaurantsFetchRequested()),
        );
      } else {
        return Padding(
          padding:
              EdgeInsets.only(top: totalRestaurants == 0 ? AppSpacing.md : 0),
          child: RestaurantsLoaderItem(
            key: ValueKey(index),
            onPresented: () => hasMoreRestaurants
                ? context
                    .read<RestaurantsBloc>()
                    .add(const RestaurantsFetchRequested())
                : null,
          ),
        );
      }
    }

    final openNow = restaurant.openNow;

    final card = RestaurantCard(
      key: ValueKey(restaurant.placeId),
      restaurant: restaurant,
    );
    if (openNow) return card;
    return Opacity(opacity: 0.6, child: card);
  }
}
