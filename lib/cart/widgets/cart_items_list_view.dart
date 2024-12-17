import 'package:api/api.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_eats_2/cart/bloc/cart_bloc.dart';

import 'package:vital_eats_2/cart/widgets/widgets.dart';

class CartItemsListView extends StatelessWidget {
  const CartItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDeliveryFee =
        context.select((CartBloc bloc) => bloc.state.orderDeliveryFee);
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

    return SliverList.list(
      children: [
        ...ListTile.divideTiles(
          context: context,
          tiles: [
            ...cartItems.map((item) {
              return CartItemCard(key: ValueKey(item.id), item: item);
            }),
            ListTile(
              title: const Text('Delivered by Glovo'),
              trailing: Text(
                orderDeliveryFee.currencyFormat(),
              ),
              leadingAndTrailingTextStyle: context.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
