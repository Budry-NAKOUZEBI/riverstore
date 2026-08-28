import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/providers/cart_providers.dart';

const _product = Product(
  id: 'p1',
  name: 'Sneakers running',
  description: 'Confortables et légères.',
  price: 89,
  category: 'Chaussures',
  imageUrl: 'https://example.com/image.png',
  rating: 4.5,
  stock: 8,
);

void main() {
  group('CartNotifier', () {
    test('addProduct adds a new item with quantity 1 by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cartProvider.notifier).addProduct(_product);

      final cart = container.read(cartProvider);
      expect(cart.items.length, 1);
      expect(cart.items['p1']!.quantity, 1);
      expect(cart.totalPrice, 89);
    });

    test('addProduct increments quantity when product already in cart', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(cartProvider.notifier);

      notifier.addProduct(_product);
      notifier.addProduct(_product);

      expect(container.read(cartProvider).items['p1']!.quantity, 2);
      expect(container.read(cartTotalPriceProvider), 178);
    });

    test('setQuantity to zero removes the item', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(cartProvider.notifier);

      notifier.addProduct(_product);
      notifier.setQuantity('p1', 0);

      expect(container.read(cartProvider).isEmpty, isTrue);
    });

    test('clear empties the cart', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(cartProvider.notifier);

      notifier.addProduct(_product, quantity: 3);
      notifier.clear();

      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(container.read(cartItemCountProvider), 0);
    });
  });
}
