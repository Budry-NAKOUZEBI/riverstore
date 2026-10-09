import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverstore/src/data/models/product_category.dart';
import 'package:riverstore/src/data/models/product_filter.dart';
import 'package:riverstore/src/providers/filter_providers.dart';
import 'package:riverstore/src/providers/product_providers.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

List<String> ids(ProductFilter filter, {String language = 'fr'}) =>
    applyFilterAndSort(
      testProducts,
      filter,
      languageCode: language,
    ).map((p) => p.id).toList();

void main() {
  group('applyFilterAndSort', () {
    test('filters by category', () {
      expect(ids(const ProductFilter(category: ProductCategory.electronics)), [
        'p1',
        'p4',
      ]);
    });

    test('search ignores case and accents', () {
      expect(ids(const ProductFilter(searchQuery: 'ECRAN')), ['p4']);
    });

    test('search matches names in every language', () {
      expect(ids(const ProductFilter(searchQuery: 'desk')), ['p3']);
      expect(ids(const ProductFilter(searchQuery: 'lampe')), ['p3']);
    });

    test('sorts by price in both directions', () {
      expect(ids(const ProductFilter(sortOption: SortOption.priceLowToHigh)), [
        'p3',
        'p1',
        'p2',
        'p4',
      ]);
      expect(ids(const ProductFilter(sortOption: SortOption.priceHighToLow)), [
        'p4',
        'p2',
        'p1',
        'p3',
      ]);
    });

    test('sorts by rating, best first', () {
      expect(ids(const ProductFilter(sortOption: SortOption.ratingHighToLow)), [
        'p1',
        'p2',
        'p4',
        'p3',
      ]);
    });

    test('sorts alphabetically in the displayed language', () {
      const filter = ProductFilter(sortOption: SortOption.nameAToZ);
      // fr : Casque, Écran, Lampe, Sneakers
      expect(ids(filter), ['p1', 'p4', 'p3', 'p2']);
      // en : Curved, Desk, Headphones, Running
      expect(ids(filter, language: 'en'), ['p4', 'p3', 'p1', 'p2']);
    });
  });

  test(
    'filteredProductsProvider combines the catalog and the filter',
    () async {
      final container = ProviderContainer.test(
        overrides: [
          productRepositoryProvider.overrideWithValue(FakeProductRepository()),
        ],
      );
      container.listen(filteredProductsProvider('fr'), (_, _) {});
      await container.read(productsProvider.future);

      container.read(filterProvider.notifier)
        ..setCategory(ProductCategory.home)
        ..setSortOption(SortOption.priceHighToLow);
      expect(
        container.read(filteredProductsProvider('fr')).value!.map((p) => p.id),
        ['p3'],
      );

      container.read(filterProvider.notifier).reset();
      expect(container.read(filterProvider).isDefault, isTrue);
      expect(
        container.read(filteredProductsProvider('fr')).value,
        hasLength(4),
      );
      expect(container.read(categoriesProvider), [
        ProductCategory.shoes,
        ProductCategory.electronics,
        ProductCategory.home,
      ]);
    },
  );
}
