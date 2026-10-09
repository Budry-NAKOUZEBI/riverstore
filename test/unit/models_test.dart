import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/cart.dart';
import 'package:riverstore/src/data/models/localized_text.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/models/product_category.dart';

import '../helpers/fixtures.dart';

void main() {
  group('LocalizedText', () {
    const text = LocalizedText({'fr': 'Bonjour', 'en': 'Hello'});

    test('resolves the requested language', () {
      expect(text.resolve('en'), 'Hello');
      expect(text.resolve('fr'), 'Bonjour');
    });

    test('falls back to French for unsupported languages', () {
      expect(text.resolve('de'), 'Bonjour');
    });

    test('accepts a plain string as French text', () {
      expect(LocalizedText.fromJson('Salut').resolve('en'), 'Salut');
    });
  });

  group('Product.fromJson', () {
    Map<String, dynamic> json({Object price = 19.9}) => {
      'id': 'p2',
      'name': {'fr': 'T-shirt', 'en': 'T-shirt EN'},
      'description': {'fr': 'Coton', 'en': 'Cotton'},
      'price': price,
      'category': 'clothing',
      'imageUrl': 'https://example.com/full.png',
      'thumbnailUrl': 'https://example.com/thumb.png',
      'rating': 4.6,
      'stock': 40,
    };

    test('parses bilingual fields and converts the price to cents', () {
      final product = Product.fromJson(json());
      expect(product.name.resolve('en'), 'T-shirt EN');
      expect(product.priceInCents, 1990); // 19.9 * 100 sans erreur d'arrondi
      expect(product.category, ProductCategory.clothing);
      expect(product.thumbnailUrl, 'https://example.com/thumb.png');
      expect(product.inStock, isTrue);
    });

    test('uses the full image when no thumbnail is provided', () {
      final product = Product.fromJson(json()..remove('thumbnailUrl'));
      expect(product.thumbnailUrl, product.imageUrl);
    });

    test('rejects unknown categories', () {
      expect(
        () => Product.fromJson(json()..['category'] = 'toys'),
        throwsArgumentError,
      );
    });

    test('products are equal when they share the same id', () {
      expect(
        buildProduct(id: 'x', nameFr: 'A'),
        buildProduct(id: 'x', nameFr: 'B'),
      );
    });
  });

  group('OrderPricing', () {
    test('charges standard shipping below the free shipping threshold', () {
      const pricing = OrderPricing(subtotalInCents: 4990);
      expect(pricing.shippingInCents, OrderPricing.standardShippingInCents);
      expect(pricing.totalInCents, 4990 + 490);
      expect(pricing.remainingForFreeShippingInCents, 10);
    });

    test('offers shipping from 50 € and for an empty cart', () {
      expect(const OrderPricing(subtotalInCents: 5000).shippingInCents, 0);
      expect(const OrderPricing(subtotalInCents: 0).totalInCents, 0);
      expect(
        const OrderPricing(
          subtotalInCents: 9000,
        ).remainingForFreeShippingInCents,
        0,
      );
    });
  });

  group('ProductIdList', () {
    test('compares by value so select() can skip identical lists', () {
      expect(const ProductIdList(['a', 'b']), const ProductIdList(['a', 'b']));
      expect(
        const ProductIdList(['a', 'b']) == const ProductIdList(['b', 'a']),
        isFalse,
      );
    });
  });
}
