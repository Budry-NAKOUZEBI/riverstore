import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

/// Injection de dépendance : expose l'implémentation du repository.
/// Peut être surchargé dans les tests pour fournir un repository factice.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return const MockProductRepository();
});

/// Charge le catalogue de produits de façon asynchrone. Le résultat est
/// exposé sous forme d'[AsyncValue] afin que l'UI puisse distinguer les
/// états chargement / données / erreur.
final productListProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).fetchProducts();
});

/// Liste triée des catégories disponibles, dérivée du catalogue.
final categoriesProvider = Provider<AsyncValue<List<String>>>((ref) {
  return ref.watch(productListProvider).whenData((products) {
    final categories = products.map((p) => p.category).toSet().toList()
      ..sort();
    return categories;
  });
});

/// Recherche un produit par identifiant au sein du catalogue déjà chargé.
final productByIdProvider =
    Provider.family<AsyncValue<Product>, String>((ref, productId) {
  final productsAsync = ref.watch(productListProvider);
  return productsAsync.when(
    data: (products) {
      for (final product in products) {
        if (product.id == productId) {
          return AsyncValue.data(product);
        }
      }
      return AsyncValue.error(
        ProductNotFoundException(productId),
        StackTrace.current,
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});
