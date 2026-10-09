import 'package:flutter/foundation.dart';

import 'cart.dart';

/// Villes desservies par la livraison à domicile.
const deliveryCities = ['Brazzaville', 'Pointe-Noire', 'Dolisie'];

enum PaymentMethod { mtnMobileMoney, airtelMoney, cashOnDelivery }

@immutable
class ShippingAddress {
  const ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.city,
    required this.district,
    required this.street,
  });

  final String fullName;
  final String phone;
  final String city;

  /// Quartier ou arrondissement (Bacongo, Poto-Poto, Moungali…).
  final String district;

  /// Rue, numéro et point de repère : les adresses se donnent souvent
  /// par rapport à un lieu connu.
  final String street;
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.items,
    required this.pricing,
    required this.address,
    required this.paymentMethod,
    required this.placedAt,
  });

  final String id;
  final List<CartItem> items;
  final OrderPricing pricing;
  final ShippingAddress address;
  final PaymentMethod paymentMethod;
  final DateTime placedAt;

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
}
