import 'package:flutter/material.dart';

/// Langue choisie par l'utilisateur ; [system] suit la langue de l'appareil.
enum AppLanguage {
  system(null),
  fr(Locale('fr')),
  en(Locale('en'));

  const AppLanguage(this.locale);

  final Locale? locale;
}

@immutable
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.system,
    this.themeMode = ThemeMode.system,
  });

  final AppLanguage language;
  final ThemeMode themeMode;

  AppSettings copyWith({AppLanguage? language, ThemeMode? themeMode}) =>
      AppSettings(
        language: language ?? this.language,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.themeMode == themeMode;

  @override
  int get hashCode => Object.hash(language, themeMode);
}
