import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/cart.dart';
import 'package:riverstore/src/data/models/localized_text.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/models/product_category.dart';
import 'package:riverstore/src/data/models/user_profile.dart';

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
    Map<String, dynamic> json({Object price = 15000}) => {
      'id': 'p2',
      'name': {'fr': 'T-shirt', 'en': 'T-shirt EN'},
      'description': {'fr': 'Coton', 'en': 'Cotton'},
      'price': price,
      'category': 'fashion',
      'imageUrl': 'https://example.com/full.png',
      'thumbnailUrl': 'https://example.com/thumb.png',
      'rating': 4.6,
      'stock': 40,
    };

    test('parses bilingual fields and an integer FCFA price', () {
      final product = Product.fromJson(json());
      expect(product.name.resolve('en'), 'T-shirt EN');
      expect(product.price, 15000);
      expect(Product.fromJson(json(price: 12500.0)).price, 12500);
      expect(product.category, ProductCategory.fashion);
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
    test('charges 2 000 FCFA delivery below the free shipping threshold', () {
      const pricing = OrderPricing(subtotal: 49000);
      expect(pricing.shipping, OrderPricing.deliveryFee);
      expect(pricing.total, 51000);
      expect(pricing.remainingForFreeShipping, 1000);
    });

    test('offers delivery from 50 000 FCFA and for an empty cart', () {
      expect(const OrderPricing(subtotal: 50000).shipping, 0);
      expect(const OrderPricing(subtotal: 0).total, 0);
      expect(const OrderPricing(subtotal: 90000).remainingForFreeShipping, 0);
    });
  });

  group('UserProfile', () {
    test('derives first name and initials', () {
      final user = UserProfile(
        id: 'u',
        name: 'Grâce Mabiala',
        email: 'g@example.cg',
        phone: '06 000 00 00',
        city: 'Brazzaville',
        memberSince: DateTime(2024),
        totalOrders: 0,
      );
      expect(user.firstName, 'Grâce');
      expect(user.initials, 'GM');
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
