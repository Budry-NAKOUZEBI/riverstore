import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/providers/order_providers.dart';
import 'package:riverstore/src/ui/screens/checkout_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<ProviderContainer> pumpCheckout(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 1.5;
  addTearDown(tester.view.reset);
  final container = await tester.pumpLocalized(const CheckoutScreen());
  container.read(cartProvider.notifier).addProduct(pagne);
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('prefills the profile and validates every field', (tester) async {
    final container = await pumpCheckout(tester);

    // Nom et téléphone viennent du profil, Brazzaville est présélectionnée.
    expect(find.text(testUser.name), findsOneWidget);
    expect(find.text(testUser.phone), findsOneWidget);
    expect(find.text('Brazzaville'), findsOneWidget);

    await tester.enterText(field('Téléphone'), '07 123');
    // 18 000 FCFA + 2 000 FCFA de livraison.
    await tester.tap(find.text('Payer 20 000 FCFA'));
    await tester.pumpAndSettle();

    expect(find.text('Numéro invalide (ex. 06 123 45 67)'), findsOneWidget);
    expect(find.text('Ce champ est obligatoire'), findsNWidgets(2));
    expect(container.read(orderHistoryProvider), isEmpty);
  });

  testWidgets('phone field filters out letters', (tester) async {
    await pumpCheckout(tester);
    await tester.enterText(field('Téléphone'), '06a612 34 56');
    expect(find.text('06612 34 56'), findsOneWidget);
  });

  testWidgets('offers MTN, Airtel and cash on delivery', (tester) async {
    await pumpCheckout(tester);
    expect(find.text('MTN Mobile Money'), findsOneWidget);
    expect(find.text('Airtel Money'), findsOneWidget);
    expect(find.text('Espèces à la livraison'), findsOneWidget);
  });

  testWidgets('shows an empty state if the cart is empty', (tester) async {
    await tester.pumpLocalized(const CheckoutScreen());
    await tester.pumpAndSettle();
    expect(find.text('Votre panier est vide.'), findsOneWidget);
  });
}
