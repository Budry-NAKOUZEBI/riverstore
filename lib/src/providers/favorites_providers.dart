import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/favorites_storage.dart';
import 'core_providers.dart';

final favoritesStorageProvider = Provider<FavoritesStorage>((ref) {
  return FavoritesStorage(ref.watch(sharedPreferencesProvider));
});

/// Gère l'ensemble des identifiants de produits favoris et les persiste
/// localement à chaque modification.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._storage) : super(_storage.read());

  final FavoritesStorage _storage;

  Future<void> toggle(String productId) async {
    final updated = {...state};
    if (!updated.remove(productId)) {
      updated.add(productId);
    }
    state = updated;
    await _storage.write(updated);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesStorageProvider));
});

/// Provider dérivé pratique pour savoir si un produit précis est favori,
/// sans reconstruire les widgets qui ne s'intéressent qu'à cet état.
final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(favoritesProvider).contains(productId);
});
