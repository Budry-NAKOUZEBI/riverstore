import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cart_item.dart';
import '../data/models/product.dart';

/// Gère l'état du panier : ajout, suppression et mise à jour des
/// quantités.
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addProduct(Product product, {int quantity = 1}) {
    final items = {...state.items};
    final existing = items[product.id];
    items[product.id] = existing == null
        ? CartItem(product: product, quantity: quantity)
        : existing.copyWith(quantity: existing.quantity + quantity);
    state = state.copyWith(items: items);
  }

  void removeProduct(String productId) {
    final items = {...state.items}..remove(productId);
    state = state.copyWith(items: items);
  }

  void setQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    final existing = state.items[productId];
    if (existing == null) return;
    final items = {...state.items};
    items[productId] = existing.copyWith(quantity: quantity);
    state = state.copyWith(items: items);
  }

  void increment(String productId) {
    final existing = state.items[productId];
    if (existing != null) setQuantity(productId, existing.quantity + 1);
  }

  void decrement(String productId) {
    final existing = state.items[productId];
    if (existing != null) setQuantity(productId, existing.quantity - 1);
  }

  void clear() => state = const CartState();
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Providers dérivés pour exposer des valeurs calculées sans dupliquer
/// la logique dans les widgets (badge du panier, résumé de commande...).
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalQuantity;
});

final cartTotalPriceProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalPrice;
});
