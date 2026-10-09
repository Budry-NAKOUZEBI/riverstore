import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/router/app_router.dart';
import 'package:riverstore/src/router/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

const french = {SettingsStorage.languageKey: 'fr'};

void main() {
  testWidgets('follows the device language by default (English here)', (
    tester,
  ) async {
    await tester.pumpFullApp();
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Wax print fabric'), findsOneWidget);
  });

  testWidgets('switching language in settings updates the whole app', (
    tester,
  ) async {
    await tester.pumpFullApp(preferences: french);
    expect(find.text('Catalogue'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Paramètres'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(SettingsStorage.languageKey), 'en');
  });

  testWidgets('cart badge reflects the number of items', (tester) async {
    final container = await tester.pumpFullApp(preferences: french);
    final semantics = tester.ensureSemantics();

    container.read(cartProvider.notifier).addProduct(pot, quantity: 2);
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('2 articles dans le panier')),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('checkout places an order and shows the confirmation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.5;
    addTearDown(tester.view.reset);
    final container = await tester.pumpFullApp(preferences: french);
    container.read(cartProvider.notifier).addProduct(pagne);
    container.read(routerProvider).go(AppRoutes.checkout);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quartier / arrondissement'),
      testAddress.district,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Adresse et point de repère'),
      testAddress.street,
    );
    await tester.tap(find.text('Airtel Money'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payer 20\u00a0000\u00a0FCFA'));
    await tester.pumpAndSettle();

    expect(find.text('Commande confirmée'), findsOneWidget);
    expect(
      find.text('Merci Grâce ! Votre commande est en préparation.'),
      findsOneWidget,
    );
    expect(find.text('Paiement : Airtel Money'), findsOneWidget);
    expect(container.read(cartProvider).isEmpty, isTrue);

    await tester.ensureVisible(find.text('Continuer mes achats'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer mes achats'));
    await tester.pumpAndSettle();
    expect(find.text('Catalogue'), findsOneWidget);
  });

  testWidgets('unknown routes show a friendly page', (tester) async {
    final container = await tester.pumpFullApp(preferences: french);
    container.read(routerProvider).go('/does-not-exist');
    await tester.pumpAndSettle();
    expect(find.text('Page introuvable.'), findsOneWidget);
  });
}
