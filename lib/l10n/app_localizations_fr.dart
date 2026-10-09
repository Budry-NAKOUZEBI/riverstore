// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'RiverStore';

  @override
  String get navCatalog => 'Catalogue';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navCart => 'Panier';

  @override
  String get navProfile => 'Profil';

  @override
  String cartBadgeSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles dans le panier',
      one: '1 article dans le panier',
      zero: 'Panier vide',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Rechercher un produit…';

  @override
  String get searchLabel => 'Rechercher';

  @override
  String get searchClear => 'Effacer la recherche';

  @override
  String get categoryFilterLabel => 'Filtrer par catégorie';

  @override
  String get categoryAll => 'Tous';

  @override
  String get categoryShoes => 'Chaussures';

  @override
  String get categoryElectronics => 'High-tech';

  @override
  String get categoryHome => 'Maison';

  @override
  String get sortLabel => 'Trier';

  @override
  String get sortRelevance => 'Pertinence';

  @override
  String get sortPriceLowToHigh => 'Prix croissant';

  @override
  String get sortPriceHighToLow => 'Prix décroissant';

  @override
  String get sortRating => 'Meilleures notes';

  @override
  String get sortName => 'Nom (A-Z)';

  @override
  String get catalogLoading => 'Chargement du catalogue…';

  @override
  String get catalogError => 'Impossible de charger les produits.';

  @override
  String get catalogEmpty => 'Aucun produit ne correspond à votre recherche.';

  @override
  String get resetFilters => 'Réinitialiser les filtres';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement…';

  @override
  String get pageNotFound => 'Page introuvable.';

  @override
  String get backToCatalog => 'Retour au catalogue';

  @override
  String productCardSemantics(String name, String price, String rating) {
    return '$name, $price, noté $rating sur 5';
  }

  @override
  String get productCardHint => 'voir le détail';

  @override
  String ratingSemantics(String rating) {
    return 'Note : $rating sur 5';
  }

  @override
  String get outOfStock => 'Rupture de stock';

  @override
  String inStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en stock',
      one: '1 en stock',
    );
    return '$_temp0';
  }

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String addToCartTooltip(String name) {
    return 'Ajouter $name au panier';
  }

  @override
  String addedToCart(String name) {
    return '$name ajouté au panier';
  }

  @override
  String inCartCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count déjà dans le panier',
      one: '1 déjà dans le panier',
    );
    return '$_temp0';
  }

  @override
  String get stockLimitReached => 'Stock maximum atteint pour ce produit';

  @override
  String get viewCart => 'Voir le panier';

  @override
  String get productDetailTitle => 'Détail produit';

  @override
  String get productNotFound => 'Ce produit n\'existe pas ou plus.';

  @override
  String get favoritesTitle => 'Mes favoris';

  @override
  String get favoritesEmpty =>
      'Aucun favori pour l\'instant.\nTouchez le cœur d\'un produit pour le retrouver ici.';

  @override
  String get cartTitle => 'Mon panier';

  @override
  String get cartEmpty => 'Votre panier est vide.';

  @override
  String get startShopping => 'Découvrir le catalogue';

  @override
  String get clearCart => 'Vider le panier';

  @override
  String get clearCartConfirmTitle => 'Vider le panier ?';

  @override
  String get clearCartConfirmBody =>
      'Tous les articles seront retirés du panier.';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get undo => 'Annuler';

  @override
  String removeItem(String name) {
    return 'Retirer $name du panier';
  }

  @override
  String itemRemoved(String name) {
    return '$name retiré du panier';
  }

  @override
  String decreaseQuantity(String name) {
    return 'Diminuer la quantité de $name';
  }

  @override
  String increaseQuantity(String name) {
    return 'Augmenter la quantité de $name';
  }

  @override
  String quantitySemantics(int quantity) {
    return 'Quantité : $quantity';
  }

  @override
  String cartItemSubtitle(String price, String subtotal) {
    return '$price l\'unité · $subtotal';
  }

  @override
  String get subtotal => 'Sous-total';

  @override
  String get shipping => 'Livraison à domicile';

  @override
  String get shippingFree => 'Offerte';

  @override
  String get total => 'Total';

  @override
  String freeShippingHint(String amount) {
    return 'Plus que $amount pour la livraison offerte';
  }

  @override
  String get checkout => 'Commander';

  @override
  String get checkoutTitle => 'Livraison & paiement';

  @override
  String get fieldFullName => 'Nom complet';

  @override
  String get fieldStreet => 'Adresse et point de repère';

  @override
  String get fieldCity => 'Ville';

  @override
  String get errorRequired => 'Ce champ est obligatoire';

  @override
  String get errorTooShort => 'Valeur trop courte';

  @override
  String get orderSummary => 'Récapitulatif';

  @override
  String placeOrder(String total) {
    return 'Payer $total';
  }

  @override
  String get placingOrder => 'Envoi de la commande…';

  @override
  String get paymentNotice =>
      'Démonstration : aucune transaction Mobile Money réelle n\'est effectuée.';

  @override
  String get orderFailed => 'La commande n\'a pas pu être envoyée. Réessayez.';

  @override
  String get orderConfirmedTitle => 'Commande confirmée';

  @override
  String orderConfirmedMessage(String name) {
    return 'Merci $name ! Votre commande est en préparation.';
  }

  @override
  String orderNumber(String id) {
    return 'Commande n° $id';
  }

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get orderDeliveryTo => 'Livraison à';

  @override
  String get continueShopping => 'Continuer mes achats';

  @override
  String get orderMissing => 'Commande introuvable.';

  @override
  String get profileTitle => 'Profil';

  @override
  String memberSince(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Membre depuis le $dateString';
  }

  @override
  String get statOrders => 'Commandes';

  @override
  String get statFavorites => 'Favoris';

  @override
  String get statCart => 'Panier';

  @override
  String get recentOrders => 'Commandes de la session';

  @override
  String get noRecentOrders => 'Aucune commande passée pendant cette session.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSubtitle => 'Langue, thème, à propos';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Langue de l\'appareil';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeSystem => 'Auto';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get settingsAbout => 'À propos';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get licenses => 'Licences open source';

  @override
  String get categoryFashion => 'Mode & pagnes';

  @override
  String get categoryCrafts => 'Artisanat';

  @override
  String get heroGreeting => 'Mbote !';

  @override
  String get heroTitle => 'Le meilleur de Brazzaville, livré chez vous.';

  @override
  String get heroSubtitle =>
      'Mode, artisanat et high-tech, livrés à Brazzaville, Pointe-Noire et Dolisie.';

  @override
  String heroBadge(String amount) {
    return 'Livraison offerte dès $amount';
  }

  @override
  String greetingUser(String name) {
    return 'Mbote, $name';
  }

  @override
  String productImageSemantics(String name) {
    return 'Photo : $name';
  }

  @override
  String get fieldPhone => 'Téléphone';

  @override
  String get fieldPhoneHint => '06 123 45 67';

  @override
  String get fieldDistrict => 'Quartier / arrondissement';

  @override
  String get fieldDistrictHint => 'Bacongo, Poto-Poto, Moungali…';

  @override
  String get fieldStreetHint => 'Rue, numéro, près de…';

  @override
  String get errorInvalidPhone => 'Numéro invalide (ex. 06 123 45 67)';

  @override
  String get sectionDelivery => 'Adresse de livraison';

  @override
  String get sectionPayment => 'Moyen de paiement';

  @override
  String get paymentMtn => 'MTN Mobile Money';

  @override
  String get paymentAirtel => 'Airtel Money';

  @override
  String get paymentCash => 'Espèces à la livraison';

  @override
  String get paymentMobileHint =>
      'Une demande de validation est envoyée sur votre téléphone.';

  @override
  String get paymentCashHint => 'Payez le livreur en espèces à la réception.';

  @override
  String orderPaidWith(String method) {
    return 'Paiement : $method';
  }

  @override
  String profileContact(String phone, String city) {
    return '$phone · $city';
  }

  @override
  String avatarSemantics(String name) {
    return 'Initiales de $name';
  }

  @override
  String productCategoryLabel(String category) {
    return 'Catégorie : $category';
  }

  @override
  String get detailDescription => 'Description';

  @override
  String get detailPrice => 'Prix';
}
