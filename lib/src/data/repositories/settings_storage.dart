import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import 'key_value_store.dart';

/// Persiste les préférences (langue, thème). Une valeur inconnue retombe
/// sur la valeur par défaut au lieu de faire planter l'app.
class SettingsStorage extends KeyValueStore<AppSettings> {
  const SettingsStorage(super.preferences);

  static const languageKey = 'settings.language';
  static const themeModeKey = 'settings.theme_mode';

  @override
  AppSettings get defaultValue => const AppSettings();

  @override
  AppSettings decode() => AppSettings(
    language:
        _byName(AppLanguage.values, preferences.getString(languageKey)) ??
        defaultValue.language,
    themeMode:
        _byName(ThemeMode.values, preferences.getString(themeModeKey)) ??
        defaultValue.themeMode,
  );

  @override
  Future<void> write(AppSettings value) async {
    await preferences.setString(languageKey, value.language.name);
    await preferences.setString(themeModeKey, value.themeMode.name);
  }

  /// Recherche générique d'une valeur d'énumération par son nom.
  static E? _byName<E extends Enum>(List<E> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
