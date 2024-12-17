// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'cart_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartState _$CartStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'CartState',
      json,
      ($checkedConvert) {
        final val = CartState(
          restaurant: $checkedConvert(
              'restaurant',
              (v) => v == null
                  ? null
                  : Restaurant.fromJson(v as Map<String, dynamic>)),
          cartItems: $checkedConvert(
              'cart_items',
              (v) => const CartItemsJsonConverter()
                  .fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'cartItems': 'cart_items'},
    );

Map<String, dynamic> _$CartStateToJson(CartState instance) => <String, dynamic>{
      if (instance.restaurant?.toJson() case final value?) 'restaurant': value,
      'cart_items': const CartItemsJsonConverter().toJson(instance.cartItems),
    };
