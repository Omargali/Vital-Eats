import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/routes/app_routes.dart';
import 'package:vital_eats_2/map/bloc/location_bloc.dart';
import 'package:vital_eats_2/profile/widgets/widgets.dart';
import 'package:vital_eats_2/search/widgets/search_bar.dart';

class RestaurantsAppBar extends StatelessWidget {
  const RestaurantsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 12,
      floating: true,
      collapsedHeight: 133,
      flexibleSpace: Column(
        children: [
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: Row(
              children: [
                UserProfileAvatar(),
                AddressButton(),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SearchBar(enabled: false),
          ),
        ],
      ),
    );
  }
}

class AddressButton extends StatelessWidget {
  const AddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Tappable.faded(
          fadeStrength: FadeStrength.lg,
          onTap: () => context.pushNamed(AppRoutes.googleMap.name),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AddressAndDeliveryText(),
              BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  final address = state.address.toString();
                  final isLoading = state.status.isLoading;

                  if (isLoading || address.isEmpty) {
                    return ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: 18,
                        width: context.screenWidth * .5,
                      ),
                      child: ShimmerPlaceholder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                    );
                  }

                  return Text(
                    address,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressAndDeliveryText extends StatelessWidget {
  const AddressAndDeliveryText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your address and delivery time',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: context.bodyMedium?.apply(color: AppColors.grey),
        ),
        const AppIcon(
          icon: Icons.arrow_right,
          iconSize: AppSize.lg,
          color: AppColors.grey,
        ),
      ],
    );
  }
}
