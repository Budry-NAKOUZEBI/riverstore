import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/core_providers.dart';

/// Construit l'application avec ses dépendances. Utilisé par `main.dart`
/// et par les tests d'intégration (qui y injectent leurs surcharges).
/// Déclare les licences OFL des polices embarquées (visibles dans
/// Paramètres → Licences open source).
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in const [
      ('Bricolage Grotesque', 'assets/fonts/OFL-BricolageGrotesque.txt'),
      ('Plus Jakarta Sans', 'assets/fonts/OFL-PlusJakartaSans.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString(file));
    }
  });
}

Widget buildApp({
  required SharedPreferences preferences,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      ...overrides,
    ],
    // Les erreurs sont présentées à l'utilisateur avec un bouton
    // « Réessayer » : pas de nouvelle tentative automatique en arrière-plan.
    retry: (_, _) => null,
    child: const RiverStoreApp(),
  );
}
