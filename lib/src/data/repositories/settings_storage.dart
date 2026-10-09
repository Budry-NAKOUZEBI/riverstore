import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

/// Persiste les préférences (langue, thème). Une valeur inconnue ou absente
/// retombe sur la valeur par défaut au lieu de faire planter l'app.
class SettingsStorage {
  const SettingsStorage(this._prefs);

  static const languageKey = 'settings.language';
  static const themeModeKey = 'settings.theme_mode';

  final SharedPreferences _prefs;

  AppSettings read() {
    return AppSettings(
      language:
          _byName(AppLanguage.values, _prefs.getString(languageKey)) ??
          AppLanguage.system,
      themeMode:
          _byName(ThemeMode.values, _prefs.getString(themeModeKey)) ??
          ThemeMode.system,
    );
  }

  Future<void> write(AppSettings settings) async {
    await _prefs.setString(languageKey, settings.language.name);
    await _prefs.setString(themeModeKey, settings.themeMode.name);
  }

  static T? _byName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
