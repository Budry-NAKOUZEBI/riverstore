enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  nameAToZ,
}

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.relevance:
        return 'Pertinence';
      case SortOption.priceLowToHigh:
        return 'Prix croissant';
      case SortOption.priceHighToLow:
        return 'Prix décroissant';
      case SortOption.ratingHighToLow:
        return 'Meilleures notes';
      case SortOption.nameAToZ:
        return 'Nom (A-Z)';
    }
  }
}

class ProductFilter {
  const ProductFilter({
    this.category,
    this.searchQuery = '',
    this.sortOption = SortOption.relevance,
  });

  final String? category;
  final String searchQuery;
  final SortOption sortOption;

  ProductFilter copyWith({
    String? category,
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
}
