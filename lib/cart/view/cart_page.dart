import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/routes/routes.dart';
import 'package:vital_eats_2/cart/bloc/cart_bloc.dart';
import 'package:vital_eats_2/cart/cart.dart';
import 'package:vital_eats_2/menu/menu.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartView();
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final isCartEmpty = context.select((CartBloc bloc) => bloc.state.isCartEmpty);

    return AppScaffold(
      bottomNavigationBar: 
      CartBottomBar(
        info: restaurant?.formattedDeliveryTime() ?? '15 - 20 min',
        title: 'Next',
        onPressed: () {},
        ),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop || restaurant == null) return;
        return context.goNamed(
          AppRoutes.menu.name,
          extra: MenuProps(restaurant: restaurant),
        );
      },
      body: CustomScrollView(
        slivers: [
          const CartAppBar(),
          if (isCartEmpty) const CartEmptyView() else const CartItemsListView(),
        ],
      ),
    );
  }
}


class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your cart is empty',
            style: context.titleLarge,
          ),
          ShadButton.outline(
            onPressed: context.pop,
            icon: const Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(LucideIcons.shoppingCart),
            ),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }
}

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  Future<void> _showClearCartDialog({required BuildContext context}) =>
      context.confirmAction(
        title: 'Clear cart',
        content: 'Are you sure to clear the cart?',
        yesText: 'Yes, clear',
        noText: 'No, keep it',
        fn: () {
          context.pop();
          context.read<CartBloc>().add(
            CartClearRequested(
              goToMenu: (restaurant) {
                if (restaurant == null) return context.pop();
                return context.goNamed(
                  AppRoutes.menu.name,
                  extra: MenuProps(restaurant: restaurant),
                );
              },
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final isCartEmpty =
        context.select((CartBloc bloc) => bloc.state.isCartEmpty);

    return SliverAppBar(
      title: Text('Cart', style: context.headlineSmall),
      scrolledUnderElevation: 2,
      expandedHeight: 80,
      excludeHeaderSemantics: true,
      pinned: true,
      leading: AppIcon.button(
        icon: Icons.adaptive.arrow_back,
        onTap: () => restaurant == null
            ? () => context.pop()
            : context.goNamed(
                AppRoutes.menu.name,
                extra: MenuProps(restaurant: restaurant),
              ),
      ),
       actions: isCartEmpty
          ? null
          : [
              AppIcon.button(
                icon: LucideIcons.trash,
                onTap: () => _showClearCartDialog(context: context),),
            ],
    );
  }
}
