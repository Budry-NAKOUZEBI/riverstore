import 'package:shared_preferences/shared_preferences.dart';

/// Persiste les identifiants de produits favoris localement via
/// SharedPreferences.
class FavoritesStorage {
  const FavoritesStorage(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'favorite_product_ids';

  Set<String> read() => _prefs.getStringList(_key)?.toSet() ?? <String>{};

  Future<void> write(Set<String> ids) =>
      _prefs.setStringList(_key, ids.toList());
}
