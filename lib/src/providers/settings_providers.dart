import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/app_settings.dart';
import '../data/repositories/settings_storage.dart';
import 'core_providers.dart';

final settingsStorageProvider = Provider<SettingsStorage>(
  (ref) => SettingsStorage(ref.watch(sharedPreferencesProvider)),
);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsStorageProvider).read();

  Future<void> setLanguage(AppLanguage language) =>
      _update(state.copyWith(language: language));

  Future<void> setThemeMode(ThemeMode themeMode) =>
      _update(state.copyWith(themeMode: themeMode));

  Future<void> _update(AppSettings settings) async {
    state = settings;
    await ref.read(settingsStorageProvider).write(settings);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

final localeProvider = Provider<Locale?>(
  (ref) => ref.watch(settingsProvider.select((s) => s.language.locale)),
);

final themeModeProvider = Provider<ThemeMode>(
  (ref) => ref.watch(settingsProvider.select((s) => s.themeMode)),
);
