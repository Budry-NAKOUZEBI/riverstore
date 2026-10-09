import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/cart.dart';
import '../data/models/product.dart';

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  /// Ajoute [quantity] exemplaires sans jamais dépasser le stock.
  /// Renvoie `false` si rien n'a pu être ajouté.
  bool addProduct(Product product, {int quantity = 1}) {
    final current = state.quantityOf(product.id);
    final target = (current + quantity).clamp(0, product.stock);
    if (target <= current) return false;
    _put(product, target);
    return true;
  }

  void removeProduct(String productId) {
    if (!state.items.containsKey(productId)) return;
    state = CartState(items: {...state.items}..remove(productId));
  }

  void setQuantity(String productId, int quantity) {
    final existing = state.items[productId];
    if (existing == null) return;
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    _put(existing.product, quantity.clamp(1, existing.product.stock));
  }

  void increment(String productId) =>
      setQuantity(productId, state.quantityOf(productId) + 1);

  void decrement(String productId) =>
      setQuantity(productId, state.quantityOf(productId) - 1);

  void clear() => state = const CartState();

  void _put(Product product, int quantity) {
    state = CartState(
      items: {
        ...state.items,
        product.id: CartItem(product: product, quantity: quantity),
      },
    );
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

/// Providers dérivés : chaque widget n'écoute que la valeur dont il a besoin.
final cartItemCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).totalQuantity,
);

final cartProductIdsProvider = Provider<ProductIdList>(
  (ref) => ref.watch(cartProvider).productIds,
);

final cartItemProvider = Provider.family<CartItem?, String>(
  (ref, productId) => ref.watch(cartProvider.select((c) => c.items[productId])),
);

final cartPricingProvider = Provider<OrderPricing>(
  (ref) => OrderPricing(subtotal: ref.watch(cartProvider).subtotal),
);
