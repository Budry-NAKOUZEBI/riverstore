import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/text_utils.dart';
import '../data/models/product.dart';
import '../data/models/product_category.dart';
import '../data/models/product_filter.dart';
import 'product_providers.dart';

class FilterNotifier extends Notifier<ProductFilter> {
  @override
  ProductFilter build() => const ProductFilter();

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);

  void setCategory(ProductCategory? category) => state = category == null
      ? state.copyWith(clearCategory: true)
      : state.copyWith(category: category);

  void setSortOption(SortOption option) =>
      state = state.copyWith(sortOption: option);

  void reset() => state = const ProductFilter();
}

final filterProvider = NotifierProvider<FilterNotifier, ProductFilter>(
  FilterNotifier.new,
);

/// Filtrage et tri purs, testables sans provider. La recherche porte sur
/// toutes les traductions du nom et ignore la casse et les accents ; le tri
/// alphabétique utilise la langue affichée.
List<Product> applyFilterAndSort(
  List<Product> products,
  ProductFilter filter, {
  required String languageCode,
}) {
  final query = normalizeForSearch(filter.searchQuery);
  final result = products.where((product) {
    if (filter.category != null && product.category != filter.category) {
      return false;
    }
    if (query.isEmpty) return true;
    return product.name.all.any(
      (name) => normalizeForSearch(name).contains(query),
    );
  }).toList();

  switch (filter.sortOption) {
    case SortOption.relevance:
      break;
    case SortOption.priceLowToHigh:
      result.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHighToLow:
      result.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.ratingHighToLow:
      result.sort((a, b) => b.rating.compareTo(a.rating));
    case SortOption.nameAToZ:
      result.sort(
        (a, b) => normalizeForSearch(
          a.name.resolve(languageCode),
        ).compareTo(normalizeForSearch(b.name.resolve(languageCode))),
      );
  }
  return result;
}

/// Catalogue filtré pour une langue donnée (paramètre de la famille).
final filteredProductsProvider =
    Provider.family<AsyncValue<List<Product>>, String>((ref, languageCode) {
      final filter = ref.watch(filterProvider);
      return ref
          .watch(productsProvider)
          .whenData(
            (products) => applyFilterAndSort(
              products,
              filter,
              languageCode: languageCode,
            ),
          );
    });
