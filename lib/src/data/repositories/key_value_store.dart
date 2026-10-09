import 'package:shared_preferences/shared_preferences.dart';

/// Stockage local typé d'une valeur de type [T] dans SharedPreferences.
///
/// Classe abstraite générique : chaque sous-classe ne décrit que la
/// conversion entre [T] et le stockage ; la lecture tolère les données
/// absentes ou corrompues en renvoyant [defaultValue].
abstract class KeyValueStore<T> {
  const KeyValueStore(this.preferences);

  final SharedPreferences preferences;

  /// Valeur utilisée lorsque rien n'est stocké ou que la donnée est
  /// illisible.
  T get defaultValue;

  /// Décode la valeur stockée, ou renvoie `null` si elle est absente ou
  /// invalide.
  T? decode();

  Future<void> write(T value);

  T read() {
    try {
      return decode() ?? defaultValue;
    } on Object {
      // Une préférence corrompue ne doit jamais empêcher l'app de démarrer.
      return defaultValue;
    }
  }
}
