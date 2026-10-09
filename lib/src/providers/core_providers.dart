import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Instance de SharedPreferences, injectée au démarrage (voir `main.dart`)
/// ou dans les tests via `overrideWithValue`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider doit être surchargé dans ProviderScope.',
  );
});
