import 'package:api/api.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_eats_2/menu/menu.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    required this.item,
    required this.restaurantPlaceId,
    required this.isOpened,
    super.key,
  });

  final MenuItem item;
  final String restaurantPlaceId;
  final bool isOpened;

  Future<void> _showRestaurantClosedDialog({
    required BuildContext context,
  }) =>
      context.showInfoDialog(
        title: 'Restaurant closed',
        content: "You can't add items from closed restaurant.",
      );

  Future<void> _onAddItemTap({
    required BuildContext context,
    required MenuItem item,
  }) async {
    if(!isOpened) return _showRestaurantClosedDialog(context: context);

    await HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      borderRadius: AppSpacing.xlg,
      backgroundColor: context.customReversedAdaptiveColor(
        dark: AppColors.background,
        light: AppColors.brightGrey,
      ),
       onTap: () => context.showScrollableModal(
        minChildSize: .6,
        maxChildSize: .85,
        initialChildSize: .85,
        snapSizes: [.85],
        pageBuilder: (scrollController, _) => MenuItemPreview(
          item: item,
          restaurantPlaceId: restaurantPlaceId,
          scrollController: scrollController,
          isOpened: isOpened,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ImageAttachmentThumbnail(
                imageUrl: item.imageUrl,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiscountPrice(
                  defaultPrice: item.formattedPrice,
                  defaultPriceStyle: context.titleMedium,
                  discountPriceStyle: context.titleLarge,
                  hasDiscount: item.hasDiscount,
                  discountPrice: item.formattedPriceWithDiscount(),
                ),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyLarge,
                ),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium?.apply(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
              AddItemButton(
                onAddItemTap: () => _onAddItemTap(
                  context: context,
                  item: item,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({required this.onAddItemTap, super.key});

  final VoidCallback onAddItemTap;

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      fadeStrength: FadeStrength.lg,
      onTap: onAddItemTap,
      backgroundColor: context.customReversedAdaptiveColor(
        dark: AppColors.emphasizeDarkGrey,
        light: AppColors.white,
      ),
      borderRadius: AppSpacing.lg,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(icon: LucideIcons.plus),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Add',
              style: context.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
