import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverstore/src/data/models/app_settings.dart';
import 'package:riverstore/src/data/repositories/favorites_storage.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/providers/core_providers.dart';
import 'package:riverstore/src/providers/favorites_providers.dart';
import 'package:riverstore/src/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<(ProviderContainer, SharedPreferences)> makeContainer([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer.test(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  return (container, prefs);
}

void main() {
  group('FavoritesNotifier', () {
    test('toggle adds then removes an id and persists it', () async {
      final (container, prefs) = await makeContainer();
      final favorites = container.read(favoritesProvider.notifier);

      await favorites.toggle('p2');
      expect(container.read(isFavoriteProvider('p2')), isTrue);
      expect(prefs.getStringList(FavoritesStorage.key), ['p2']);

      await favorites.toggle('p2');
      expect(container.read(favoritesProvider), isEmpty);
      expect(prefs.getStringList(FavoritesStorage.key), isEmpty);
    });

    test('restores favorites saved during a previous session', () async {
      final (container, _) = await makeContainer({
        FavoritesStorage.key: ['p1', 'p3'],
      });
      expect(container.read(favoritesProvider), {'p1', 'p3'});
      expect(container.read(favoritesCountProvider), 2);
    });
  });

  group('SettingsNotifier', () {
    test('defaults to the device language and system theme', () async {
      final (container, _) = await makeContainer();
      expect(container.read(settingsProvider), const AppSettings());
      expect(container.read(localeProvider), isNull);
    });

    test('persists language and theme changes', () async {
      final (container, prefs) = await makeContainer();
      final settings = container.read(settingsProvider.notifier);

      await settings.setLanguage(AppLanguage.en);
      await settings.setThemeMode(ThemeMode.dark);

      expect(container.read(localeProvider), const Locale('en'));
      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(prefs.getString(SettingsStorage.languageKey), 'en');
      expect(prefs.getString(SettingsStorage.themeModeKey), 'dark');
    });

    test('ignores corrupted stored values instead of crashing', () async {
      final (container, _) = await makeContainer({
        SettingsStorage.languageKey: 'klingon',
        SettingsStorage.themeModeKey: 'light',
      });
      final settings = container.read(settingsProvider);
      expect(settings.language, AppLanguage.system);
      expect(settings.themeMode, ThemeMode.light);
    });
  });
}
