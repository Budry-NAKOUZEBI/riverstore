import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/cart.dart';
import 'package:riverstore/src/data/repositories/order_repository.dart';
import 'package:riverstore/src/data/repositories/product_repository.dart';

import '../helpers/fixtures.dart';

void main() {
  group('AssetProductRepository', () {
    final raw = File(AssetProductRepository.assetPath).readAsStringSync();

    test('parses the bundled catalog', () {
      final products = AssetProductRepository.parseProducts(raw);
      expect(products, hasLength(14));
      expect(products.map((p) => p.id).toSet(), hasLength(14));
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
        expect(product.priceInCents, greaterThan(0));
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
        items: [CartItem(product: lamp, quantity: 2)],
        address: testAddress,
      );
      expect(order.id, startsWith('RS-'));
      expect(order.placedAt, placedAt);
      expect(order.itemCount, 2);
      expect(order.pricing.subtotalInCents, 4980);
      expect(order.pricing.totalInCents, 4980 + 490);
    });

    test('refuses an empty cart', () {
      expect(
        repository.placeOrder(items: const [], address: testAddress),
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
