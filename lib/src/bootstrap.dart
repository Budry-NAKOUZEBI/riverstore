import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/core_providers.dart';

/// Construit l'application avec ses dépendances. Utilisé par `main.dart`
/// et par les tests d'intégration (qui y injectent leurs surcharges).
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
