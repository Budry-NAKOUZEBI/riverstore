import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/models/product_filter.dart';
import 'package:riverstore/src/providers/filter_providers.dart';

final _products = [
  const Product(
    id: 'p1',
    name: 'Casque audio',
    description: 'd',
    price: 79.9,
    category: 'Électronique',
    imageUrl: 'u',
    rating: 4.7,
    stock: 15,
  ),
  const Product(
    id: 'p2',
    name: 'Sneakers running',
    description: 'd',
    price: 89,
    category: 'Chaussures',
    imageUrl: 'u',
    rating: 4.5,
    stock: 8,
  ),
  const Product(
    id: 'p3',
    name: 'Enceinte Bluetooth',
    description: 'd',
    price: 59,
    category: 'Électronique',
    imageUrl: 'u',
    rating: 4.1,
    stock: 22,
  ),
];

void main() {
  group('applyFilterAndSort', () {
    test('filters by category', () {
      final result =
          applyFilterAndSort(_products, const ProductFilter(category: 'Électronique'));
      expect(result.map((p) => p.id), ['p1', 'p3']);
    });

    test('filters by search query, case-insensitive', () {
      final result =
          applyFilterAndSort(_products, const ProductFilter(searchQuery: 'sneakers'));
      expect(result.map((p) => p.id), ['p2']);
    });

    test('sorts by price ascending', () {
      final result = applyFilterAndSort(
        _products,
        const ProductFilter(sortOption: SortOption.priceLowToHigh),
      );
      expect(result.map((p) => p.id), ['p3', 'p1', 'p2']);
    });

    test('sorts by rating descending', () {
      final result = applyFilterAndSort(
        _products,
        const ProductFilter(sortOption: SortOption.ratingHighToLow),
      );
      expect(result.map((p) => p.id), ['p1', 'p2', 'p3']);
    });
  });
}
