import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_eats_2/restaurants/bloc/restaurants_bloc.dart';
import 'package:vital_eats_2/restaurants/filters/widgets/widgets.dart';
import 'package:vital_eats_2/restaurants/tags/tags.dart';

class TagsSlider extends StatelessWidget {
  const TagsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.select((RestaurantsBloc bloc) => bloc.state.tags);
    final chosenTags =
        context.select((RestaurantsBloc bloc) => bloc.state.chosenTags);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 84,
          child: ListView.separated(
            key: const PageStorageKey('categoriesPageKey'),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: tags.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) return const FilterButton();
              if (tags.length + 1 == index) return const MoreFiltersButton();
              final categoryIndex = index - 1;
              final tag = tags[categoryIndex];

              return TagCard.sm(
                tag: tag,
                selected: chosenTags.contains(tag),
              );
            },
          ),
        ),
      ),
    );
  }
}
