import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_eats_2/restaurants/bloc/restaurants_bloc.dart';
import 'package:vital_eats_2/restaurants/filters/view/filters_view.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  void _onTap(BuildContext context) {
    Future<void>.delayed(200.ms, () {
      context.showScrollableModal(
        pageBuilder: (scrollController, draggableScrollController) =>
        FilterModalView(
          scrollController: scrollController,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chosenTags =
        context.select((RestaurantsBloc bloc) => bloc.state.chosenTags);
    final chosenTagsCount = chosenTags.length;

    return Tappable.scaled(
      onTap: () => _onTap(context),
      child: Column(
        children: [
          Badge(
            alignment: Alignment.topRight,
            backgroundColor: AppColors.transparent,
            offset: const Offset(-6, 0),
            isLabelVisible: chosenTagsCount != 0,
            largeSize: 20,
            label: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: AppColors.black.withOpacity(.4),
                  ),
                ],
              ),
              child: Text(
                '$chosenTagsCount',
                style: context.bodyMedium?.apply(color: AppColors.white),
              ),
            ),
            child: Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.brightGrey,
                borderRadius:
                    BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
              ),
              child: Assets.icons.filterIcon.svg(),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Filters'),
        ],
      ),
    );
  }
}
