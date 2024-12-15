// ignore_for_file: avoid_dynamic_calls

import 'dart:math';

import 'package:api/api.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/routes/app_routes.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final name = restaurant.name;
    final rating = restaurant.rating as double;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Tappable.faded(
        onTap: () => context.pushNamed(
          AppRoutes.menu.name,
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                RestaurantImage(restaurant: restaurant),
              ],
            ),
            Hero(
              tag: 'Menu$name',
              child: Text(
                restaurant.name,
                style: context.titleLarge
                    ?.copyWith(fontWeight: AppFontWeight.bold),
              ),
            ),
            Row(
              children: [
                AppIcon(
                  icon: LucideIcons.star,
                  color: rating <= 4.4 ? AppColors.grey : AppColors.green,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(restaurant.formattedRating),
                const SizedBox(width: AppSpacing.xs),
                if (restaurant.isRatingEnough)
                  Text(
                    restaurant.review,
                    style: context.bodyMedium?.apply(
                      color: restaurant.userRatingsTotal >= 30
                          ? context.customReversedAdaptiveColor(
                              light: AppColors.black,
                              dark: AppColors.white,
                            )
                          : context.customReversedAdaptiveColor(
                              light: AppColors.background,
                              dark: AppColors.brightGrey,
                            ),
                    ),
                  ),
                  RestaurantPriceLevel(priceLevel: restaurant.priceLevel),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(restaurant.formattedTags),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantImage extends StatelessWidget {
  const RestaurantImage({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final (:thumbnailWidth, :thumbnailHeight, :imageUrl) = () {
      final unsplashUrlRegExp = RegExp(r'^https:\/\/images\.unsplash\.com\/');
      if (!unsplashUrlRegExp.hasMatch(restaurant.imageUrl)) {
        return (
          thumbnailHeight: null,
          thumbnailWidth: null,
          imageUrl: restaurant.imageUrl
        );
      }

      final screenWidth = context.screenWidth;
      final pixelRatio = context.devicePixelRatio;

      // AppSpacing.md * 2 is the horizontal padding of the screen.
      final thumbnailWidth =
          min(((screenWidth - (AppSpacing.md * 2)) * pixelRatio) ~/ 1, 1920);
      final thumbnailHeight = min((thumbnailWidth * (9 / 16)).toInt(), 1080);

      final widthRegExp = RegExp(r'w=\d+');
      final heightRegExp = RegExp(r'h=\d+');
      final imageUrl = restaurant.imageUrl.replaceFirst(
        widthRegExp,
        'w=$thumbnailWidth',
      );
      final queryParameters = Uri.parse(imageUrl).queryParameters;
      final finalImageUrl = imageUrl.contains(heightRegExp)
          ? imageUrl.replaceFirst(
              heightRegExp,
              'h=$thumbnailHeight',
            )
          : Uri.parse(imageUrl).replace(
              queryParameters: {
                ...queryParameters,
                'h': '$thumbnailHeight',
              },
            ).toString();
      return (
        thumbnailHeight: thumbnailHeight,
        thumbnailWidth: thumbnailWidth,
        imageUrl: finalImageUrl,
      );
    }();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ImageAttachmentThumbnail(
        imageUrl: imageUrl,
        memCacheHeight: thumbnailHeight,
        memCacheWidth: thumbnailWidth,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
    );
  }
}

class RestaurantPriceLevel extends StatelessWidget {
  const RestaurantPriceLevel({
    required this.priceLevel,
    super.key,
  });

  final int priceLevel;

  @override
  Widget build(BuildContext context) {
    TextStyle? effectiveStyle(int level) {
      return context.bodyMedium?.apply(
        color: priceLevel >= level
            ? context.customReversedAdaptiveColor(
                light: AppColors.black,
                dark: AppColors.white,
              )
            : AppColors.grey,
      );
    }
     return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: currency, style: effectiveStyle(1)),
          TextSpan(text: currency, style: effectiveStyle(2)),
          TextSpan(text: currency, style: effectiveStyle(3)),
        ],
      ),
    );
  }
}
