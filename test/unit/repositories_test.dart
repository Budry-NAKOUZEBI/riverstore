import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/cart.dart';
import 'package:riverstore/src/data/models/order.dart';
import 'package:riverstore/src/data/repositories/order_repository.dart';
import 'package:riverstore/src/data/repositories/product_repository.dart';

import '../helpers/fixtures.dart';

void main() {
  group('AssetProductRepository', () {
    final raw = File(AssetProductRepository.assetPath).readAsStringSync();

    test('parses the bundled catalog', () {
      final products = AssetProductRepository.parseProducts(raw);
      expect(products, hasLength(17));
      expect(products.map((p) => p.id).toSet(), hasLength(17));
    });

    test('every product is translated in French and English', () {
      for (final product in AssetProductRepository.parseProducts(raw)) {
        for (final text in [product.name, product.description]) {
          expect(
            text.values.keys,
            containsAll(['fr', 'en']),
            reason: product.id,
          );
          expect(text.values.values.every((v) => v.isNotEmpty), isTrue);
        }
        // Prix réalistes en FCFA, arrondis à 500 FCFA près.
        expect(product.price, greaterThanOrEqualTo(1000));
        expect(product.price % 500, 0, reason: product.id);
        expect(product.thumbnailUrl, isNot(product.imageUrl));
      }
    });
  });

  group('MockOrderRepository', () {
    final placedAt = DateTime(2026, 10, 9, 14, 30);
    final repository = MockOrderRepository(
      latency: Duration.zero,
      clock: () => placedAt,
    );

    test('creates an order with an id, pricing and timestamp', () async {
      final order = await repository.placeOrder(
        items: [CartItem(product: pot, quantity: 2)],
        address: testAddress,
        paymentMethod: PaymentMethod.airtelMoney,
      );
      expect(order.id, startsWith('RS-'));
      expect(order.placedAt, placedAt);
      expect(order.itemCount, 2);
      expect(order.paymentMethod, PaymentMethod.airtelMoney);
      expect(order.pricing.subtotal, 28000);
      expect(order.pricing.total, 30000);
    });

    test('refuses an empty cart', () {
      expect(
        repository.placeOrder(
          items: const [],
          address: testAddress,
          paymentMethod: PaymentMethod.cashOnDelivery,
        ),
        throwsA(isA<EmptyCartException>()),
      );
    });
  });

  test('French and English translation files define the same keys', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((key) => !key.startsWith('@'))
            .toSet();
    expect(keys('lib/l10n/app_en.arb'), keys('lib/l10n/app_fr.arb'));
  });
}
