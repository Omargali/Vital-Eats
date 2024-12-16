import 'package:api/api.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MenuItemPreview extends StatelessWidget {
  const MenuItemPreview({
    required this.item,
    required this.scrollController,
    required this.isOpened,
    this.restaurantPlaceId,
    super.key,
  });

  final MenuItem item;
  final String? restaurantPlaceId;
  final bool isOpened;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        controller: scrollController,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ImageAttachmentThumbnail(imageUrl: item.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: IncreaseDecreaseQuantityBottomAppBar(
        item: item,
        restaurantPlaceId: restaurantPlaceId,
        isOpened: isOpened,
      ),
    );
  }
}

class IncreaseDecreaseQuantityBottomAppBar extends StatefulWidget {
  const IncreaseDecreaseQuantityBottomAppBar({
    required this.item,
    required this.restaurantPlaceId,
    required this.isOpened,
    super.key,
  });

  final MenuItem item;
  final String? restaurantPlaceId;
  final bool isOpened;

  @override
  State<IncreaseDecreaseQuantityBottomAppBar> createState() =>
      _IncreaseDecreaseQuantityBottomAppBarState();
}

class _IncreaseDecreaseQuantityBottomAppBarState
    extends State<IncreaseDecreaseQuantityBottomAppBar> {
  late ValueNotifier<int> _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = ValueNotifier(1);
  }

  Future<void> _showRestaurantClosedDialog({
    required BuildContext context,
  }) =>
      context.showInfoDialog(
        title: 'Restaurant closed',
        content: "You can't add items from closed restaurant.",
      );

  Future<void> _onAddItemTap() async {
    if (!widget.isOpened) return _showRestaurantClosedDialog(context: context);
    
    await HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomBar(
      children: [
        Row(
          children: [
            Text(widget.item.name, style: context.bodyLarge),
            const Spacer(),
            Text(
              widget.item.formattedPriceWithDiscount(),
              style: context.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ValueListenableBuilder<int>(
          valueListenable: _quantity,
          builder: (context, quantity, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    border: Border.all(
                      color: AppColors.grey.withOpacity(.6),
                    ),
                  ),
                  child: Row(
                    children: [
                      AppIcon.button(
                        icon: LucideIcons.minus,
                        iconSize: AppSize.sm,
                        onTap: quantity == 1
                            ? null
                            : () {
                                _quantity.value = _quantity.value - 1;
                              },
                      ),
                      Text(quantity.toString()),
                      AnimatedOpacity(
                        duration: 150.ms,
                        opacity: quantity >= 100 ? .4 : 1,
                        child: AppIcon.button(
                          icon: LucideIcons.plus,
                          iconSize: AppSize.sm,
                          onTap:
                              quantity >= 100 ? null : () => _quantity.value++,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ShadButton(
                    onPressed: () async {
                      void pushBack() => context.pop();
                      await _onAddItemTap();
                      pushBack();
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
