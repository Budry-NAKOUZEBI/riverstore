import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../core/errors.dart';
import '../core/formatters.dart' as formatters;
import '../core/validators.dart';
import '../data/models/order.dart';
import '../data/models/product_category.dart';
import '../data/models/product_filter.dart';

export '../../l10n/app_localizations.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Langue effectivement affichée (après résolution des locales).
  String get languageCode => Localizations.localeOf(this).languageCode;

  /// Montant en francs CFA formaté selon la langue (`25 000 FCFA`).
  String formatPrice(int amount) =>
      formatters.formatPrice(amount, Localizations.localeOf(this).toString());
}

extension ProductCategoryLabel on ProductCategory {
  String label(AppLocalizations l10n) => switch (this) {
    ProductCategory.fashion => l10n.categoryFashion,
    ProductCategory.shoes => l10n.categoryShoes,
    ProductCategory.electronics => l10n.categoryElectronics,
    ProductCategory.home => l10n.categoryHome,
    ProductCategory.crafts => l10n.categoryCrafts,
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
    ValidationError.invalidPhone => l10n.errorInvalidPhone,
  };
}

extension PaymentMethodLabel on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMethod.mtnMobileMoney => l10n.paymentMtn,
    PaymentMethod.airtelMoney => l10n.paymentAirtel,
    PaymentMethod.cashOnDelivery => l10n.paymentCash,
  };

  String hint(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cashOnDelivery => l10n.paymentCashHint,
    _ => l10n.paymentMobileHint,
  };
}

/// Message traduit pour n'importe quelle erreur. Le `switch` sur la classe
/// scellée [AppException] est exhaustif : ajouter un nouveau type d'erreur
/// sans message provoque une erreur de compilation.
String userMessageFor(Object error, AppLocalizations l10n) => switch (error) {
  CatalogLoadException() => l10n.catalogError,
  ProductNotFoundException() => l10n.productNotFound,
  EmptyCartException() => l10n.cartEmpty,
  OrderFailedException() => l10n.orderFailed,
  _ => l10n.errorUnexpected,
};
