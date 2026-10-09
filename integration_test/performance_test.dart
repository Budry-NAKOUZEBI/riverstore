import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverstore/src/bootstrap.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/ui/widgets/product_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mesure les temps de frame pendant le défilement du catalogue.
///
/// Les chiffres sont significatifs en mode profile :
/// `flutter drive --profile --driver=test_driver/integration_test.dart \
///   --target=integration_test/performance_test.dart`
/// En mode debug (CI), on vérifie seulement l'absence de dérive grossière.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('scrolling the catalog stays within the 60 fps budget', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({SettingsStorage.languageKey: 'fr'});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(buildApp(preferences: preferences));
    await tester.pumpAndSettle();

    final grid = find.descendant(
      of: find.byType(ProductGrid),
      matching: find.byType(Scrollable),
    );

    await binding.watchPerformance(() async {
      for (var i = 0; i < 3; i++) {
        await tester.fling(grid, const Offset(0, -800), 2500);
        await tester.pumpAndSettle();
        await tester.fling(grid, const Offset(0, 800), 2500);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'catalog_scrolling');

    final summary =
        binding.reportData!['catalog_scrolling'] as Map<String, dynamic>;
    debugPrint('catalog_scrolling: $summary');

    // Budget d'une frame à 60 fps : 16,7 ms.
    expect(summary['average_frame_build_time_millis'] as num, lessThan(16.7));
  });
}
