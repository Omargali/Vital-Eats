import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:vital_eats_2/restaurants/filters/view/filters_view.dart';

class MoreFiltersButton extends StatelessWidget {
  const MoreFiltersButton({super.key});

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
    return Tappable.scaled(
      onTap: () => _onTap(context),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.brightGrey,
              borderRadius:
                  BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
            ),
            child: const Icon(
              LucideIcons.arrowRight,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('More'),
        ],
      ),
    );
  }
}
