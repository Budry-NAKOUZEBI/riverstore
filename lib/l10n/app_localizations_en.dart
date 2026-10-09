// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RiverStore';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String cartBadgeSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items in cart',
      one: '1 item in cart',
      zero: 'Cart is empty',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Search for a product…';

  @override
  String get searchLabel => 'Search';

  @override
  String get searchClear => 'Clear search';

  @override
  String get categoryFilterLabel => 'Filter by category';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryShoes => 'Shoes';

  @override
  String get categoryElectronics => 'Tech';

  @override
  String get categoryHome => 'Home';

  @override
  String get sortLabel => 'Sort';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortPriceLowToHigh => 'Price: low to high';

  @override
  String get sortPriceHighToLow => 'Price: high to low';

  @override
  String get sortRating => 'Top rated';

  @override
  String get sortName => 'Name (A-Z)';

  @override
  String get catalogLoading => 'Loading catalog…';

  @override
  String get catalogError => 'Unable to load products.';

  @override
  String get catalogEmpty => 'No product matches your search.';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String get pageNotFound => 'Page not found.';

  @override
  String get backToCatalog => 'Back to catalog';

  @override
  String productCardSemantics(String name, String price, String rating) {
    return '$name, $price, rated $rating out of 5';
  }

  @override
  String get productCardHint => 'view details';

  @override
  String ratingSemantics(String rating) {
    return 'Rating: $rating out of 5';
  }

  @override
  String get outOfStock => 'Out of stock';

  @override
  String inStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in stock',
      one: '1 in stock',
    );
    return '$_temp0';
  }

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get addToCart => 'Add to cart';

  @override
  String addToCartTooltip(String name) {
    return 'Add $name to cart';
  }

  @override
  String addedToCart(String name) {
    return '$name added to cart';
  }

  @override
  String inCartCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count already in cart',
      one: '1 already in cart',
    );
    return '$_temp0';
  }

  @override
  String get stockLimitReached => 'Maximum stock reached for this product';

  @override
  String get viewCart => 'View cart';

  @override
  String get productDetailTitle => 'Product details';

  @override
  String get productNotFound => 'This product does not exist anymore.';

  @override
  String get favoritesTitle => 'My favorites';

  @override
  String get favoritesEmpty =>
      'You have no favorites yet.\nTap the heart on a product to add it here.';

  @override
  String get cartTitle => 'My cart';

  @override
  String get cartEmpty => 'Your cart is empty.';

  @override
  String get startShopping => 'Browse the catalog';

  @override
  String get clearCart => 'Clear cart';

  @override
  String get clearCartConfirmTitle => 'Clear the cart?';

  @override
  String get clearCartConfirmBody =>
      'All items will be removed from your cart.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get undo => 'Undo';

  @override
  String removeItem(String name) {
    return 'Remove $name from cart';
  }

  @override
  String itemRemoved(String name) {
    return '$name removed from cart';
  }

  @override
  String decreaseQuantity(String name) {
    return 'Decrease quantity of $name';
  }

  @override
  String increaseQuantity(String name) {
    return 'Increase quantity of $name';
  }

  @override
  String quantitySemantics(int quantity) {
    return 'Quantity: $quantity';
  }

  @override
  String cartItemSubtitle(String price, String subtotal) {
    return '$price each · $subtotal';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Home delivery';

  @override
  String get shippingFree => 'Free';

  @override
  String get total => 'Total';

  @override
  String freeShippingHint(String amount) {
    return 'Only $amount left for free shipping';
  }

  @override
  String get checkout => 'Checkout';

  @override
  String get checkoutTitle => 'Delivery & payment';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldStreet => 'Address and landmark';

  @override
  String get fieldCity => 'City';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorTooShort => 'Value is too short';

  @override
  String get orderSummary => 'Order summary';

  @override
  String placeOrder(String total) {
    return 'Pay $total';
  }

  @override
  String get placingOrder => 'Placing order…';

  @override
  String get paymentNotice => 'Demo: no real Mobile Money transaction is made.';

  @override
  String get orderFailed => 'The order could not be placed. Please try again.';

  @override
  String get orderConfirmedTitle => 'Order confirmed';

  @override
  String orderConfirmedMessage(String name) {
    return 'Thank you $name! Your order is being prepared.';
  }

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get orderDeliveryTo => 'Delivering to';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get orderMissing => 'Order not found.';

  @override
  String get profileTitle => 'Profile';

  @override
  String memberSince(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Member since $dateString';
  }

  @override
  String get statOrders => 'Orders';

  @override
  String get statFavorites => 'Favorites';

  @override
  String get statCart => 'Cart';

  @override
  String get recentOrders => 'Orders this session';

  @override
  String get noRecentOrders => 'No order placed during this session.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Language, theme, about';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsAbout => 'About';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get licenses => 'Open source licenses';

  @override
  String get categoryFashion => 'Fashion & wax';

  @override
  String get categoryCrafts => 'Crafts';

  @override
  String get heroGreeting => 'Mbote!';

  @override
  String get heroTitle => 'The best of Brazzaville, delivered to your door.';

  @override
  String get heroSubtitle =>
      'Fashion, crafts and tech, delivered in Brazzaville, Pointe-Noire and Dolisie.';

  @override
  String heroBadge(String amount) {
    return 'Free delivery from $amount';
  }

  @override
  String greetingUser(String name) {
    return 'Mbote, $name';
  }

  @override
  String productImageSemantics(String name) {
    return 'Photo: $name';
  }

  @override
  String get fieldPhone => 'Phone number';

  @override
  String get fieldPhoneHint => '06 123 45 67';

  @override
  String get fieldDistrict => 'Neighbourhood / district';

  @override
  String get fieldDistrictHint => 'Bacongo, Poto-Poto, Moungali…';

  @override
  String get fieldStreetHint => 'Street, number, near…';

  @override
  String get errorInvalidPhone => 'Invalid number (e.g. 06 123 45 67)';

  @override
  String get sectionDelivery => 'Delivery address';

  @override
  String get sectionPayment => 'Payment method';

  @override
  String get paymentMtn => 'MTN Mobile Money';

  @override
  String get paymentAirtel => 'Airtel Money';

  @override
  String get paymentCash => 'Cash on delivery';

  @override
  String get paymentMobileHint =>
      'A confirmation request is sent to your phone.';

  @override
  String get paymentCashHint => 'Pay the courier in cash on delivery.';

  @override
  String orderPaidWith(String method) {
    return 'Payment: $method';
  }

  @override
  String profileContact(String phone, String city) {
    return '$phone · $city';
  }

  @override
  String avatarSemantics(String name) {
    return 'Initials of $name';
  }

  @override
  String productCategoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String get detailDescription => 'Description';

  @override
  String get detailPrice => 'Price';
}
