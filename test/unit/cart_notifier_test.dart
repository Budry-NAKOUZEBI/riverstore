import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverstore/src/providers/cart_providers.dart';

import '../helpers/fixtures.dart';

void main() {
  late ProviderContainer container;
  late CartNotifier cart;

  setUp(() {
    container = ProviderContainer.test();
    cart = container.read(cartProvider.notifier);
  });

  test('addProduct adds a line then increments its quantity', () {
    expect(cart.addProduct(headphones), isTrue);
    cart.addProduct(headphones);

    final state = container.read(cartProvider);
    expect(state.items.length, 1);
    expect(state.quantityOf(headphones.id), 2);
    expect(state.subtotalInCents, 2 * 7990);
  });

  test('addProduct never exceeds the available stock', () {
    // sneakers.stock == 3
    expect(cart.addProduct(sneakers, quantity: 5), isTrue);
    expect(container.read(cartProvider).quantityOf(sneakers.id), 3);
    expect(cart.addProduct(sneakers), isFalse);
  });

  test('out-of-stock products cannot be added', () {
    expect(cart.addProduct(screen), isFalse);
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  test('decrement down to zero removes the line', () {
    cart.addProduct(lamp);
    cart.decrement(lamp.id);
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  test('setQuantity clamps to stock and ignores unknown products', () {
    cart.addProduct(sneakers);
    cart.setQuantity(sneakers.id, 99);
    cart.setQuantity('unknown', 2);
    expect(container.read(cartProvider).quantityOf(sneakers.id), 3);
    expect(container.read(cartProvider).items.length, 1);
  });

  test('derived providers expose count, ids and pricing', () {
    cart.addProduct(headphones);
    cart.addProduct(lamp, quantity: 2);

    expect(container.read(cartItemCountProvider), 3);
    expect(container.read(cartProductIdsProvider).ids, [
      headphones.id,
      lamp.id,
    ]);
    final pricing = container.read(cartPricingProvider);
    expect(pricing.subtotalInCents, 7990 + 2 * 2490);
    expect(pricing.shippingInCents, 0);

    cart.clear();
    expect(container.read(cartItemCountProvider), 0);
  });

  test('changing a quantity does not notify the product id list', () async {
    cart.addProduct(headphones);
    var notifications = 0;
    container.listen(cartProductIdsProvider, (_, _) => notifications++);

    cart.increment(headphones.id);
    await container.pump();
    expect(notifications, 0);

    cart.addProduct(lamp);
    await container.pump();
    expect(notifications, 1);
  });
}
