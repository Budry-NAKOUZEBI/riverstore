import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../core/formatters.dart' as formatters;
import '../core/validators.dart';
import '../data/models/product_category.dart';
import '../data/models/product_filter.dart';

export '../../l10n/app_localizations.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Langue effectivement affichée (après résolution des locales).
  String get languageCode => Localizations.localeOf(this).languageCode;

  String formatPrice(int cents) =>
      formatters.formatPrice(cents, Localizations.localeOf(this).toString());
}

extension ProductCategoryLabel on ProductCategory {
  String label(AppLocalizations l10n) => switch (this) {
    ProductCategory.clothing => l10n.categoryClothing,
    ProductCategory.shoes => l10n.categoryShoes,
    ProductCategory.electronics => l10n.categoryElectronics,
    ProductCategory.accessories => l10n.categoryAccessories,
    ProductCategory.home => l10n.categoryHome,
  };
}

extension SortOptionLabel on SortOption {
  String label(AppLocalizations l10n) => switch (this) {
    SortOption.relevance => l10n.sortRelevance,
    SortOption.priceLowToHigh => l10n.sortPriceLowToHigh,
    SortOption.priceHighToLow => l10n.sortPriceHighToLow,
    SortOption.ratingHighToLow => l10n.sortRating,
    SortOption.nameAToZ => l10n.sortName,
  };
}

extension ValidationErrorMessage on ValidationError {
  String message(AppLocalizations l10n) => switch (this) {
    ValidationError.required => l10n.errorRequired,
    ValidationError.tooShort => l10n.errorTooShort,
    ValidationError.invalidEmail => l10n.errorInvalidEmail,
    ValidationError.invalidPostalCode => l10n.errorInvalidPostalCode,
  };
}
