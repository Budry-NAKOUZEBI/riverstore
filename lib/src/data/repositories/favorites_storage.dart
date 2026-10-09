import 'package:shared_preferences/shared_preferences.dart';

/// Persiste les identifiants des produits favoris.
class FavoritesStorage {
  const FavoritesStorage(this._prefs);

  static const key = 'favorite_product_ids';

  final SharedPreferences _prefs;

  Set<String> read() => _prefs.getStringList(key)?.toSet() ?? <String>{};

  Future<void> write(Set<String> ids) =>
      _prefs.setStringList(key, ids.toList()..sort());
}
