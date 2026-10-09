import 'package:flutter/foundation.dart';

import 'product.dart';

@immutable
class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get subtotalInCents => product.priceInCents * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  @override
  bool operator ==(Object other) =>
      other is CartItem &&
      other.product == product &&
      other.quantity == quantity;

  @override
  int get hashCode => Object.hash(product, quantity);
}

@immutable
class CartState {
  const CartState({this.items = const {}});

  /// Lignes du panier indexées par identifiant produit (ordre d'ajout).
  final Map<String, CartItem> items;

  List<CartItem> get itemList => items.values.toList(growable: false);

  ProductIdList get productIds => ProductIdList(items.keys.toList());

  int get totalQuantity =>
      items.values.fold(0, (total, item) => total + item.quantity);

  int get subtotalInCents =>
      items.values.fold(0, (total, item) => total + item.subtotalInCents);

  bool get isEmpty => items.isEmpty;

  int quantityOf(String productId) => items[productId]?.quantity ?? 0;
}

/// Liste d'identifiants comparée par valeur : utilisée avec `select` pour
/// que l'écran panier ne se reconstruise que lorsqu'une ligne est ajoutée
/// ou retirée (pas à chaque changement de quantité).
@immutable
class ProductIdList {
  const ProductIdList(this.ids);

  final List<String> ids;

  int get length => ids.length;
  String operator [](int index) => ids[index];

  @override
  bool operator ==(Object other) =>
      other is ProductIdList && listEquals(other.ids, ids);

  @override
  int get hashCode => Object.hashAll(ids);
}

/// Règles de tarification de la commande.
@immutable
class OrderPricing {
  const OrderPricing({required this.subtotalInCents});

  /// Livraison offerte à partir de 50 €.
  static const freeShippingThresholdInCents = 5000;
  static const standardShippingInCents = 490;

  final int subtotalInCents;

  int get shippingInCents =>
      subtotalInCents == 0 || subtotalInCents >= freeShippingThresholdInCents
      ? 0
      : standardShippingInCents;

  int get totalInCents => subtotalInCents + shippingInCents;

  int get remainingForFreeShippingInCents {
    final remaining = freeShippingThresholdInCents - subtotalInCents;
    return remaining > 0 ? remaining : 0;
  }

  @override
  bool operator ==(Object other) =>
      other is OrderPricing && other.subtotalInCents == subtotalInCents;

  @override
  int get hashCode => subtotalInCents.hashCode;
}
