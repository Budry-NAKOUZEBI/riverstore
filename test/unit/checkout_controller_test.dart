import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverstore/src/data/models/cart.dart';
import 'package:riverstore/src/data/models/order.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/providers/order_providers.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  late OrderRepositoryMock repository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<CartItem>[]);
    registerFallbackValue(testAddress);
  });

  setUp(() {
    repository = OrderRepositoryMock();
    container = ProviderContainer.test(
      overrides: [orderRepositoryProvider.overrideWithValue(repository)],
    );
    // Garde le provider autoDispose en vie pendant le test.
    container.listen(checkoutControllerProvider, (_, _) {});
    container.read(cartProvider.notifier).addProduct(headphones);
  });

  test('a successful order is recorded and empties the cart', () async {
    final order = Order(
      id: 'RS-1',
      items: [CartItem(product: headphones, quantity: 1)],
      pricing: const OrderPricing(subtotalInCents: 7990),
      address: testAddress,
      placedAt: DateTime(2026),
    );
    when(
      () => repository.placeOrder(
        items: any(named: 'items'),
        address: any(named: 'address'),
      ),
    ).thenAnswer((_) async => order);

    final result = await container
        .read(checkoutControllerProvider.notifier)
        .submit(testAddress);

    expect(result, order);
    expect(container.read(checkoutControllerProvider).value, order);
    expect(container.read(orderHistoryProvider), [order]);
    expect(container.read(orderByIdProvider('RS-1')), order);
    expect(container.read(cartProvider).isEmpty, isTrue);
    verify(
      () => repository.placeOrder(
        items: [CartItem(product: headphones, quantity: 1)],
        address: testAddress,
      ),
    ).called(1);
  });

  test('a failed order exposes the error and keeps the cart', () async {
    when(
      () => repository.placeOrder(
        items: any(named: 'items'),
        address: any(named: 'address'),
      ),
    ).thenThrow(Exception('network down'));

    final result = await container
        .read(checkoutControllerProvider.notifier)
        .submit(testAddress);

    expect(result, isNull);
    expect(container.read(checkoutControllerProvider).hasError, isTrue);
    expect(container.read(orderHistoryProvider), isEmpty);
    expect(container.read(cartProvider).quantityOf(headphones.id), 1);
  });
}
