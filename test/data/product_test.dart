import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/product.dart';

void main() {
  group('Product', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'p1',
        'name': 'Veste en jean',
        'description': 'Une veste intemporelle.',
        'price': 59.9,
        'category': 'Vêtements',
        'imageUrl': 'https://example.com/image.png',
        'rating': 4.3,
        'stock': 12,
      };

      final product = Product.fromJson(json);

      expect(product.id, 'p1');
      expect(product.name, 'Veste en jean');
      expect(product.price, 59.9);
      expect(product.category, 'Vêtements');
      expect(product.rating, 4.3);
      expect(product.stock, 12);
      expect(product.inStock, isTrue);
    });

    test('inStock is false when stock is zero', () {
      final product = Product.fromJson({
        'id': 'p2',
        'name': 'Article épuisé',
        'description': 'Description',
        'price': 10,
        'category': 'Maison',
        'imageUrl': 'https://example.com/image.png',
        'rating': 3.5,
        'stock': 0,
      });

      expect(product.inStock, isFalse);
    });

    test('two products with the same id are equal', () {
      const a = Product(
        id: 'p1',
        name: 'A',
        description: 'd',
        price: 1,
        category: 'c',
        imageUrl: 'u',
        rating: 1,
        stock: 1,
      );
      const b = Product(
        id: 'p1',
        name: 'B',
        description: 'd2',
        price: 2,
        category: 'c2',
        imageUrl: 'u2',
        rating: 2,
        stock: 2,
      );

      expect(a, equals(b));
    });
  });
}
