/// Hiérarchie des erreurs métier de l'application.
///
/// `sealed` : le compilateur connaît toutes les sous-classes, ce qui permet
/// un `switch` exhaustif côté interface (voir `AppException.messageKey`
/// dans `ui/l10n_extensions.dart`) sans cas « inconnu » oublié.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  /// Description technique (journaux, débogage), jamais affichée telle
  /// quelle : l'interface affiche un message traduit.
  final String message;

  /// Erreur d'origine, conservée pour le diagnostic.
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType: $message${cause == null ? '' : ' (cause : $cause)'}';
}

/// Le catalogue n'a pas pu être chargé ou décodé.
final class CatalogLoadException extends AppException {
  const CatalogLoadException(super.message, {super.cause});
}

/// Aucun produit ne correspond à l'identifiant demandé (lien périmé…).
final class ProductNotFoundException extends AppException {
  ProductNotFoundException(this.productId)
    : super('Aucun produit avec l\'identifiant « $productId ».');

  final String productId;
}

/// Tentative de commande avec un panier vide.
final class EmptyCartException extends AppException {
  const EmptyCartException() : super('Impossible de commander un panier vide.');
}

/// Le service de commande a refusé ou n'a pas pu traiter la commande.
final class OrderFailedException extends AppException {
  const OrderFailedException(super.message, {super.cause});
}
