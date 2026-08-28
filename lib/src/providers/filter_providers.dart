import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product.dart';
import '../data/models/product_filter.dart';
import 'product_providers.dart';

class FilterNotifier extends StateNotifier<ProductFilter> {
  FilterNotifier() : super(const ProductFilter());

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);

  void setCategory(String? category) {
    state = category == null
        ? state.copyWith(clearCategory: true)
        : state.copyWith(category: category);
  }

  void setSortOption(SortOption option) =>
      state = state.copyWith(sortOption: option);

  void reset() => state = const ProductFilter();
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, ProductFilter>((ref) {
  return FilterNotifier();
});

/// Fonction pure de filtrage/tri, testable indépendamment des providers.
List<Product> applyFilterAndSort(List<Product> products, ProductFilter filter) {
  final query = filter.searchQuery.trim().toLowerCase();
  final result = products.where((product) {
    final matchesCategory =
        filter.category == null || product.category == filter.category;
    final matchesQuery =
        query.isEmpty || product.name.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();

  switch (filter.sortOption) {
    case SortOption.relevance:
      break;
    case SortOption.priceLowToHigh:
      result.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceHighToLow:
      result.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.ratingHighToLow:
      result.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.nameAToZ:
      result.sort((a, b) => a.name.compareTo(b.name));
      break;
  }
  return result;
}

/// Combine le catalogue asynchrone et les critères de filtre/tri courants.
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final filter = ref.watch(filterProvider);
  final productsAsync = ref.watch(productListProvider);
  return productsAsync.whenData(
    (products) => applyFilterAndSort(products, filter),
  );
});
