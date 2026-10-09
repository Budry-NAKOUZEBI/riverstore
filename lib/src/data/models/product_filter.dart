import 'package:flutter/foundation.dart';

import 'product_category.dart';

enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  nameAToZ,
}

@immutable
class ProductFilter {
  const ProductFilter({
    this.category,
    this.searchQuery = '',
    this.sortOption = SortOption.relevance,
  });

  final ProductCategory? category;
  final String searchQuery;
  final SortOption sortOption;

  bool get isDefault =>
      category == null &&
      searchQuery.isEmpty &&
      sortOption == SortOption.relevance;

  ProductFilter copyWith({
    ProductCategory? category,
    bool clearCategory = false,
    String? searchQuery,
    SortOption? sortOption,
  }) {
    return ProductFilter(
      category: clearCategory ? null : (category ?? this.category),
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ProductFilter &&
      other.category == category &&
      other.searchQuery == searchQuery &&
      other.sortOption == sortOption;

  @override
  int get hashCode => Object.hash(category, searchQuery, sortOption);
}
