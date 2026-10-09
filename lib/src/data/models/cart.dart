import 'package:flutter/foundation.dart';

import 'product.dart';

@immutable
class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get subtotal => product.price * quantity;

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

  int get subtotal =>
      items.values.fold(0, (total, item) => total + item.subtotal);

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

/// Règles de tarification de la commande (montants en francs CFA).
@immutable
class OrderPricing {
  const OrderPricing({required this.subtotal});

  /// Livraison offerte à partir de 50 000 FCFA.
  static const freeShippingThreshold = 50000;

  /// Frais de livraison à domicile (Brazzaville, Pointe-Noire, Dolisie).
  static const deliveryFee = 2000;

  final int subtotal;

  int get shipping =>
      subtotal == 0 || subtotal >= freeShippingThreshold ? 0 : deliveryFee;

  int get total => subtotal + shipping;

  int get remainingForFreeShipping {
    final remaining = freeShippingThreshold - subtotal;
    return remaining > 0 ? remaining : 0;
  }

  @override
  bool operator ==(Object other) =>
      other is OrderPricing && other.subtotal == subtotal;

  @override
  int get hashCode => subtotal.hashCode;
}
