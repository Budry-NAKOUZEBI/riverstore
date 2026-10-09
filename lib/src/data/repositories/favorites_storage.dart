import 'key_value_store.dart';

/// Persiste les identifiants des produits favoris.
class FavoritesStorage extends KeyValueStore<Set<String>> {
  const FavoritesStorage(super.preferences);

  static const key = 'favorite_product_ids';

  @override
  Set<String> get defaultValue => <String>{};

  @override
  Set<String>? decode() => preferences.getStringList(key)?.toSet();

  @override
  Future<void> write(Set<String> value) =>
      preferences.setStringList(key, value.toList()..sort());
}
