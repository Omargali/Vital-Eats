import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_eats_2/restaurants/restaurants.dart';
import 'package:vital_eats_2/restaurants/tags/view/tags_slider.dart';

final _bucket = PageStorageBucket();

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _bucket,
      child: const RestaurantsView(),
    );
  }
}

class RestaurantsView extends StatelessWidget {
  const RestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<RestaurantsBloc>()
            .add(const RestaurantsRefreshRequested());
      },
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      strokeWidth: 3,
      backgroundColor: AppColors.white,
      color: AppColors.black,
      child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
        builder: (context, state) {
          final isLoading = state.status.isLoading;
          final isFailure = state.status.isFailure;
          final isFiltered = state.status.isFiltered;
          final restaurants = state.restaurantsPage.restaurants;
          final currentPage = state.restaurantsPage.page;

          return CustomScrollView(
            key: const PageStorageKey<String>('restaurantsPage'),
            slivers: [
              const RestaurantsAppBar(),
              if (isLoading) const RestaurantsLoadingView(),
              if (currentPage == 0 && isFailure)
                RestaurantsErrorView(
                  onTryAgain: () => context
                      .read<RestaurantsBloc>()
                      .add(const RestaurantsFetchRequested()),
                ),
              if (!isLoading && !isFailure) ...[
                if (!isFiltered) ...[
                  if (restaurants.isEmpty)
                    const RestaurantsEmptyView()
                  else ...[
                    const RestaurantsSectionHeader(text: 'All restaurants'),
                    const TagsSlider(),
                    const RestaurantsListView(),
                  ],
                ] else ...[
                  const TagsSlider(),
                  const SliverToBoxAdapter(
                    child: Divider(
                      height: 1,
                      indent: AppSpacing.md,
                      endIndent: AppSpacing.md,
                    ),
                  ),
                  const FilteredRestaurantsFoundCount(),
                  const FilteredRestaurantsListView(),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
