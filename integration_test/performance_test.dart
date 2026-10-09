import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverstore/src/bootstrap.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/ui/screens/catalog_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mesure les temps de frame pendant le défilement du catalogue.
///
/// Les chiffres sont significatifs en mode profile :
/// `flutter drive --profile --driver=test_driver/integration_test.dart \
///   --target=integration_test/performance_test.dart`
/// En mode debug (CI), on vérifie seulement l'absence de dérive grossière.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Mesure dans les deux situations réelles : sans lecteur d'écran (cas
  // courant) et avec un lecteur d'écran actif (arbre sémantique calculé à
  // chaque frame). Sur un bureau GNOME, le bus d'accessibilité force ce
  // second mode : on fixe explicitement la valeur pour des mesures stables.
  for (final screenReader in [false, true]) {
    final key = screenReader ? 'catalog_scrolling_a11y' : 'catalog_scrolling';
    testWidgets('scrolling the catalog stays within the 60 fps budget '
        '(screen reader: $screenReader)', (tester) async {
      binding.platformDispatcher.semanticsEnabledTestValue = screenReader;
      addTearDown(binding.platformDispatcher.clearSemanticsEnabledTestValue);
      SharedPreferences.setMockInitialValues({
        SettingsStorage.languageKey: 'fr',
      });
      final preferences = await SharedPreferences.getInstance();
      await tester.pumpWidget(buildApp(preferences: preferences));
      await tester.pumpAndSettle();

      final grid = find.byKey(CatalogScreen.scrollKey);
      await binding.watchPerformance(() async {
        for (var i = 0; i < 3; i++) {
          await tester.fling(grid, const Offset(0, -800), 2500);
          await tester.pumpAndSettle();
          await tester.fling(grid, const Offset(0, 800), 2500);
          await tester.pumpAndSettle();
        }
      }, reportKey: key);

      final summary = binding.reportData![key] as Map<String, dynamic>;
      debugPrint('$key: $summary');

      // Budget d'une frame à 60 fps : 16,7 ms.
      expect(summary['average_frame_build_time_millis'] as num, lessThan(16.7));
    });
  }
}
