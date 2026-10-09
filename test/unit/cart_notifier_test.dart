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
    expect(cart.addProduct(pagne), isTrue);
    cart.addProduct(pagne);

    final state = container.read(cartProvider);
    expect(state.items.length, 1);
    expect(state.quantityOf(pagne.id), 2);
    expect(state.subtotal, 36000);
  });

  test('addProduct never exceeds the available stock', () {
    // sandals.stock == 3
    expect(cart.addProduct(sandals, quantity: 5), isTrue);
    expect(container.read(cartProvider).quantityOf(sandals.id), 3);
    expect(cart.addProduct(sandals), isFalse);
  });

  test('out-of-stock products cannot be added', () {
    expect(cart.addProduct(solarKit), isFalse);
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  test('decrement down to zero removes the line', () {
    cart.addProduct(pot);
    cart.decrement(pot.id);
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  test('setQuantity clamps to stock and ignores unknown products', () {
    cart.addProduct(sandals);
    cart.setQuantity(sandals.id, 99);
    cart.setQuantity('unknown', 2);
    expect(container.read(cartProvider).quantityOf(sandals.id), 3);
    expect(container.read(cartProvider).items.length, 1);
  });

  test('derived providers expose count, ids and pricing', () {
    cart.addProduct(pagne);
    cart.addProduct(pot, quantity: 2);

    expect(container.read(cartItemCountProvider), 3);
    expect(container.read(cartProductIdsProvider).ids, [pagne.id, pot.id]);
    final pricing = container.read(cartPricingProvider);
    expect(pricing.subtotal, 18000 + 2 * 14000);
    expect(pricing.shipping, 2000, reason: '46 000 FCFA < 50 000 FCFA');

    cart.addProduct(pot);
    expect(container.read(cartPricingProvider).shipping, 0);

    cart.clear();
    expect(container.read(cartItemCountProvider), 0);
  });

  test('changing a quantity does not notify the product id list', () async {
    cart.addProduct(pagne);
    var notifications = 0;
    container.listen(cartProductIdsProvider, (_, _) => notifications++);

    cart.increment(pagne.id);
    await container.pump();
    expect(notifications, 0);

    cart.addProduct(pot);
    await container.pump();
    expect(notifications, 1);
  });
}
