import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/router/app_router.dart';
import 'package:riverstore/src/router/app_routes.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// Vérifie les recommandations Flutter d'accessibilité sur chaque écran :
/// zones tactiles ≥ 48 dp (Android) / 44 pt (iOS), éléments interactifs
/// étiquetés et contraste suffisant du texte.
Future<void> expectAccessible(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}

void main() {
  for (final (name, location) in [
    ('catalog', AppRoutes.catalog),
    ('product detail', AppRoutes.catalogProduct('p1')),
    ('favorites', AppRoutes.favorites),
    ('cart', AppRoutes.cart),
    ('checkout', AppRoutes.checkout),
    ('profile', AppRoutes.profile),
    ('settings', AppRoutes.settings),
  ]) {
    testWidgets('$name screen meets accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      final container = await tester.pumpFullApp(
        preferences: {SettingsStorage.languageKey: 'fr'},
      );
      container.read(cartProvider.notifier).addProduct(pagne);
      container.read(routerProvider).go(location);
      await tester.pumpAndSettle();

      await expectAccessible(tester);
      semantics.dispose();
    });
  }
}
