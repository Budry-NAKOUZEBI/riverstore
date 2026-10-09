/// Chemins de navigation de l'application.
abstract final class AppRoutes {
  static const catalog = '/catalog';
  static const favorites = '/favorites';
  static const cart = '/cart';
  static const checkout = '/cart/checkout';
  static const profile = '/profile';
  static const settings = '/profile/settings';

  static String catalogProduct(String id) => '$catalog/product/$id';
  static String favoriteProduct(String id) => '$favorites/product/$id';
  static String orderConfirmation(String orderId) => '/order/$orderId';
}
