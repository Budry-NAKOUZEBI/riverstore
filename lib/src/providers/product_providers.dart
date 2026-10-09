import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/product.dart';
import '../data/models/product_category.dart';
import '../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => const AssetProductRepository(),
);

/// Catalogue complet, chargé une seule fois puis gardé en mémoire.
final productsProvider = FutureProvider<List<Product>>(
  (ref) => ref.watch(productRepositoryProvider).fetchProducts(),
);

/// Catégories effectivement présentes dans le catalogue, dans l'ordre de
/// l'énumération.
final categoriesProvider = Provider<List<ProductCategory>>((ref) {
  final products = ref.watch(productsProvider).value ?? const <Product>[];
  final present = {for (final product in products) product.category};
  return [
    for (final category in ProductCategory.values)
      if (present.contains(category)) category,
  ];
});

final productByIdProvider = Provider.family<AsyncValue<Product>, String>((
  ref,
  productId,
) {
  return ref.watch(productsProvider).whenData((products) {
    for (final product in products) {
      if (product.id == productId) return product;
    }
    throw ProductNotFoundException(productId);
  });
});
