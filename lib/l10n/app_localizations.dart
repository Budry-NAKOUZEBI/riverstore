import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'RiverStore'**
  String get appTitle;

  /// No description provided for @navCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue'**
  String get navCatalog;

  /// No description provided for @navFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get navFavorites;

  /// No description provided for @navCart.
  ///
  /// In fr, this message translates to:
  /// **'Panier'**
  String get navCart;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @cartBadgeSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Panier vide} =1{1 article dans le panier} other{{count} articles dans le panier}}'**
  String cartBadgeSemantics(int count);

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un produit…'**
  String get searchHint;

  /// No description provided for @searchLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get searchLabel;

  /// No description provided for @searchClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer la recherche'**
  String get searchClear;

  /// No description provided for @categoryFilterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par catégorie'**
  String get categoryFilterLabel;

  /// No description provided for @categoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get categoryAll;

  /// No description provided for @categoryShoes.
  ///
  /// In fr, this message translates to:
  /// **'Chaussures'**
  String get categoryShoes;

  /// No description provided for @categoryElectronics.
  ///
  /// In fr, this message translates to:
  /// **'High-tech'**
  String get categoryElectronics;

  /// No description provided for @categoryHome.
  ///
  /// In fr, this message translates to:
  /// **'Maison'**
  String get categoryHome;

  /// No description provided for @sortLabel.
  ///
  /// In fr, this message translates to:
  /// **'Trier'**
  String get sortLabel;

  /// No description provided for @sortRelevance.
  ///
  /// In fr, this message translates to:
  /// **'Pertinence'**
  String get sortRelevance;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In fr, this message translates to:
  /// **'Prix croissant'**
  String get sortPriceLowToHigh;

  /// No description provided for @sortPriceHighToLow.
  ///
  /// In fr, this message translates to:
  /// **'Prix décroissant'**
  String get sortPriceHighToLow;

  /// No description provided for @sortRating.
  ///
  /// In fr, this message translates to:
  /// **'Meilleures notes'**
  String get sortRating;

  /// No description provided for @sortName.
  ///
  /// In fr, this message translates to:
  /// **'Nom (A-Z)'**
  String get sortName;

  /// No description provided for @catalogLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du catalogue…'**
  String get catalogLoading;

  /// No description provided for @catalogError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les produits.'**
  String get catalogError;

  /// No description provided for @catalogEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit ne correspond à votre recherche.'**
  String get catalogEmpty;

  /// No description provided for @resetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get resetFilters;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get loading;

  /// No description provided for @pageNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Page introuvable.'**
  String get pageNotFound;

  /// No description provided for @backToCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Retour au catalogue'**
  String get backToCatalog;

  /// No description provided for @productCardSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{name}, {price}, noté {rating} sur 5'**
  String productCardSemantics(String name, String price, String rating);

  /// No description provided for @productCardHint.
  ///
  /// In fr, this message translates to:
  /// **'voir le détail'**
  String get productCardHint;

  /// No description provided for @ratingSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Note : {rating} sur 5'**
  String ratingSemantics(String rating);

  /// No description provided for @outOfStock.
  ///
  /// In fr, this message translates to:
  /// **'Rupture de stock'**
  String get outOfStock;

  /// No description provided for @inStockCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 en stock} other{{count} en stock}}'**
  String inStockCount(int count);

  /// No description provided for @addToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get removeFromFavorites;

  /// No description provided for @addToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au panier'**
  String get addToCart;

  /// No description provided for @addToCartTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter {name} au panier'**
  String addToCartTooltip(String name);

  /// No description provided for @addedToCart.
  ///
  /// In fr, this message translates to:
  /// **'{name} ajouté au panier'**
  String addedToCart(String name);

  /// No description provided for @inCartCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 déjà dans le panier} other{{count} déjà dans le panier}}'**
  String inCartCount(int count);

  /// No description provided for @stockLimitReached.
  ///
  /// In fr, this message translates to:
  /// **'Stock maximum atteint pour ce produit'**
  String get stockLimitReached;

  /// No description provided for @viewCart.
  ///
  /// In fr, this message translates to:
  /// **'Voir le panier'**
  String get viewCart;

  /// No description provided for @productDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail produit'**
  String get productDetailTitle;

  /// No description provided for @productNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Ce produit n\'existe pas ou plus.'**
  String get productNotFound;

  /// No description provided for @favoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour l\'instant.\nTouchez le cœur d\'un produit pour le retrouver ici.'**
  String get favoritesEmpty;

  /// No description provided for @cartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon panier'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide.'**
  String get cartEmpty;

  /// No description provided for @startShopping.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir le catalogue'**
  String get startShopping;

  /// No description provided for @clearCart.
  ///
  /// In fr, this message translates to:
  /// **'Vider le panier'**
  String get clearCart;

  /// No description provided for @clearCartConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vider le panier ?'**
  String get clearCartConfirmTitle;

  /// No description provided for @clearCartConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Tous les articles seront retirés du panier.'**
  String get clearCartConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get undo;

  /// No description provided for @removeItem.
  ///
  /// In fr, this message translates to:
  /// **'Retirer {name} du panier'**
  String removeItem(String name);

  /// No description provided for @itemRemoved.
  ///
  /// In fr, this message translates to:
  /// **'{name} retiré du panier'**
  String itemRemoved(String name);

  /// No description provided for @decreaseQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer la quantité de {name}'**
  String decreaseQuantity(String name);

  /// No description provided for @increaseQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter la quantité de {name}'**
  String increaseQuantity(String name);

  /// No description provided for @quantitySemantics.
  ///
  /// In fr, this message translates to:
  /// **'Quantité : {quantity}'**
  String quantitySemantics(int quantity);

  /// No description provided for @cartItemSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{price} l\'unité · {subtotal}'**
  String cartItemSubtitle(String price, String subtotal);

  /// No description provided for @subtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get subtotal;

  /// No description provided for @shipping.
  ///
  /// In fr, this message translates to:
  /// **'Livraison à domicile'**
  String get shipping;

  /// No description provided for @shippingFree.
  ///
  /// In fr, this message translates to:
  /// **'Offerte'**
  String get shippingFree;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @freeShippingHint.
  ///
  /// In fr, this message translates to:
  /// **'Plus que {amount} pour la livraison offerte'**
  String freeShippingHint(String amount);

  /// No description provided for @checkout.
  ///
  /// In fr, this message translates to:
  /// **'Commander'**
  String get checkout;

  /// No description provided for @checkoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Livraison & paiement'**
  String get checkoutTitle;

  /// No description provided for @fieldFullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fieldFullName;

  /// No description provided for @fieldStreet.
  ///
  /// In fr, this message translates to:
  /// **'Adresse et point de repère'**
  String get fieldStreet;

  /// No description provided for @fieldCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get fieldCity;

  /// No description provided for @errorRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get errorRequired;

  /// No description provided for @errorTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Valeur trop courte'**
  String get errorTooShort;

  /// No description provided for @orderSummary.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get orderSummary;

  /// No description provided for @placeOrder.
  ///
  /// In fr, this message translates to:
  /// **'Payer {total}'**
  String placeOrder(String total);

  /// No description provided for @placingOrder.
  ///
  /// In fr, this message translates to:
  /// **'Envoi de la commande…'**
  String get placingOrder;

  /// No description provided for @paymentNotice.
  ///
  /// In fr, this message translates to:
  /// **'Démonstration : aucune transaction Mobile Money réelle n\'est effectuée.'**
  String get paymentNotice;

  /// No description provided for @orderFailed.
  ///
  /// In fr, this message translates to:
  /// **'La commande n\'a pas pu être envoyée. Réessayez.'**
  String get orderFailed;

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Commande confirmée'**
  String get orderConfirmedTitle;

  /// No description provided for @orderConfirmedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Merci {name} ! Votre commande est en préparation.'**
  String orderConfirmedMessage(String name);

  /// No description provided for @orderNumber.
  ///
  /// In fr, this message translates to:
  /// **'Commande n° {id}'**
  String orderNumber(String id);

  /// No description provided for @orderItemsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 article} other{{count} articles}}'**
  String orderItemsCount(int count);

  /// No description provided for @orderDeliveryTo.
  ///
  /// In fr, this message translates to:
  /// **'Livraison à'**
  String get orderDeliveryTo;

  /// No description provided for @continueShopping.
  ///
  /// In fr, this message translates to:
  /// **'Continuer mes achats'**
  String get continueShopping;

  /// No description provided for @orderMissing.
  ///
  /// In fr, this message translates to:
  /// **'Commande introuvable.'**
  String get orderMissing;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @memberSince.
  ///
  /// In fr, this message translates to:
  /// **'Membre depuis le {date}'**
  String memberSince(DateTime date);

  /// No description provided for @statOrders.
  ///
  /// In fr, this message translates to:
  /// **'Commandes'**
  String get statOrders;

  /// No description provided for @statFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get statFavorites;

  /// No description provided for @statCart.
  ///
  /// In fr, this message translates to:
  /// **'Panier'**
  String get statCart;

  /// No description provided for @recentOrders.
  ///
  /// In fr, this message translates to:
  /// **'Commandes de la session'**
  String get recentOrders;

  /// No description provided for @noRecentOrders.
  ///
  /// In fr, this message translates to:
  /// **'Aucune commande passée pendant cette session.'**
  String get noRecentOrders;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue, thème, à propos'**
  String get settingsSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'appareil'**
  String get languageSystem;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Auto'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAbout;

  /// No description provided for @appVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @licenses.
  ///
  /// In fr, this message translates to:
  /// **'Licences open source'**
  String get licenses;

  /// No description provided for @categoryFashion.
  ///
  /// In fr, this message translates to:
  /// **'Mode & pagnes'**
  String get categoryFashion;

  /// No description provided for @categoryCrafts.
  ///
  /// In fr, this message translates to:
  /// **'Artisanat'**
  String get categoryCrafts;

  /// No description provided for @heroGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Mbote !'**
  String get heroGreeting;

  /// No description provided for @heroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le meilleur de Brazzaville, livré chez vous.'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode, artisanat et high-tech, livrés à Brazzaville, Pointe-Noire et Dolisie.'**
  String get heroSubtitle;

  /// No description provided for @heroBadge.
  ///
  /// In fr, this message translates to:
  /// **'Livraison offerte dès {amount}'**
  String heroBadge(String amount);

  /// No description provided for @greetingUser.
  ///
  /// In fr, this message translates to:
  /// **'Mbote, {name}'**
  String greetingUser(String name);

  /// No description provided for @productImageSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Photo : {name}'**
  String productImageSemantics(String name);

  /// No description provided for @fieldPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get fieldPhone;

  /// No description provided for @fieldPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'06 123 45 67'**
  String get fieldPhoneHint;

  /// No description provided for @fieldDistrict.
  ///
  /// In fr, this message translates to:
  /// **'Quartier / arrondissement'**
  String get fieldDistrict;

  /// No description provided for @fieldDistrictHint.
  ///
  /// In fr, this message translates to:
  /// **'Bacongo, Poto-Poto, Moungali…'**
  String get fieldDistrictHint;

  /// No description provided for @fieldStreetHint.
  ///
  /// In fr, this message translates to:
  /// **'Rue, numéro, près de…'**
  String get fieldStreetHint;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro invalide (ex. 06 123 45 67)'**
  String get errorInvalidPhone;

  /// No description provided for @sectionDelivery.
  ///
  /// In fr, this message translates to:
  /// **'Adresse de livraison'**
  String get sectionDelivery;

  /// No description provided for @sectionPayment.
  ///
  /// In fr, this message translates to:
  /// **'Moyen de paiement'**
  String get sectionPayment;

  /// No description provided for @paymentMtn.
  ///
  /// In fr, this message translates to:
  /// **'MTN Mobile Money'**
  String get paymentMtn;

  /// No description provided for @paymentAirtel.
  ///
  /// In fr, this message translates to:
  /// **'Airtel Money'**
  String get paymentAirtel;

  /// No description provided for @paymentCash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces à la livraison'**
  String get paymentCash;

  /// No description provided for @paymentMobileHint.
  ///
  /// In fr, this message translates to:
  /// **'Une demande de validation est envoyée sur votre téléphone.'**
  String get paymentMobileHint;

  /// No description provided for @paymentCashHint.
  ///
  /// In fr, this message translates to:
  /// **'Payez le livreur en espèces à la réception.'**
  String get paymentCashHint;

  /// No description provided for @orderPaidWith.
  ///
  /// In fr, this message translates to:
  /// **'Paiement : {method}'**
  String orderPaidWith(String method);

  /// No description provided for @profileContact.
  ///
  /// In fr, this message translates to:
  /// **'{phone} · {city}'**
  String profileContact(String phone, String city);

  /// No description provided for @avatarSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Initiales de {name}'**
  String avatarSemantics(String name);

  /// No description provided for @productCategoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie : {category}'**
  String productCategoryLabel(String category);

  /// No description provided for @detailDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get detailDescription;

  /// No description provided for @detailPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get detailPrice;

  /// No description provided for @errorUnexpected.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue.'**
  String get errorUnexpected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
