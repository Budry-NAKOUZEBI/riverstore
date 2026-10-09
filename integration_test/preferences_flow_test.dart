import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverstore/src/bootstrap.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/ui/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favoris, langue et thème doivent survivre à un redémarrage de l'app.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('favorites, language and theme persist across restarts', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({SettingsStorage.languageKey: 'fr'});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(buildApp(preferences: preferences));
    await tester.pumpAndSettle();

    // Ajoute le premier produit aux favoris depuis le catalogue.
    await tester.tap(find.byTooltip('Ajouter aux favoris').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoris'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);

    // Passe l'application en anglais et en thème sombre.
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Paramètres'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // « Redémarrage » : nouvel arbre, nouveau ProviderScope, mêmes données.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(buildApp(preferences: preferences));
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsOneWidget);
    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Oversized denim jacket'), findsOneWidget);
  });
}
