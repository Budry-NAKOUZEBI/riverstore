import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/product.dart';
import '../data/repositories/favorites_storage.dart';
import 'core_providers.dart';
import 'product_providers.dart';

final favoritesStorageProvider = Provider<FavoritesStorage>(
  (ref) => FavoritesStorage(ref.watch(sharedPreferencesProvider)),
);

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.watch(favoritesStorageProvider).read();

  Future<void> toggle(String productId) async {
    final updated = {...state};
    if (!updated.remove(productId)) updated.add(productId);
    state = updated;
    await ref.read(favoritesStorageProvider).write(updated);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

/// Ne reconstruit que le bouton du produit concerné.
final isFavoriteProvider = Provider.family<bool, String>(
  (ref, productId) =>
      ref.watch(favoritesProvider.select((ids) => ids.contains(productId))),
);

final favoritesCountProvider = Provider<int>(
  (ref) => ref.watch(favoritesProvider).length,
);

final favoriteProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final ids = ref.watch(favoritesProvider);
  return ref
      .watch(productsProvider)
      .whenData(
        (products) => [
          for (final product in products)
            if (ids.contains(product.id)) product,
        ],
      );
});
