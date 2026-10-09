import 'package:flutter/foundation.dart';

import 'cart.dart';

@immutable
class ShippingAddress {
  const ShippingAddress({
    required this.fullName,
    required this.email,
    required this.street,
    required this.postalCode,
    required this.city,
  });

  final String fullName;
  final String email;
  final String street;
  final String postalCode;
  final String city;
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.items,
    required this.pricing,
    required this.address,
    required this.placedAt,
  });

  final String id;
  final List<CartItem> items;
  final OrderPricing pricing;
  final ShippingAddress address;
  final DateTime placedAt;

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
}
