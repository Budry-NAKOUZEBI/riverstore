import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/providers/order_providers.dart';
import 'package:riverstore/src/ui/screens/checkout_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  testWidgets('prefills the profile and validates every field', (tester) async {
    final container = await tester.pumpLocalized(const CheckoutScreen());
    container.read(cartProvider.notifier).addProduct(headphones);
    await tester.pumpAndSettle();

    // Nom et e-mail viennent du profil utilisateur.
    expect(find.text(testUser.name), findsOneWidget);
    expect(find.text(testUser.email), findsOneWidget);

    await tester.enterText(field('E-mail'), 'pas-un-email');
    await tester.enterText(field('Code postal'), '123');
    await tester.tap(find.text('Payer 79,90 €'));
    await tester.pumpAndSettle();

    expect(find.text('Adresse e-mail invalide'), findsOneWidget);
    expect(find.text('Code postal invalide (5 chiffres)'), findsOneWidget);
    expect(find.text('Ce champ est obligatoire'), findsNWidgets(2));
    expect(container.read(orderHistoryProvider), isEmpty);
  });

  testWidgets('postal code field only accepts five digits', (tester) async {
    final container = await tester.pumpLocalized(const CheckoutScreen());
    container.read(cartProvider.notifier).addProduct(headphones);
    await tester.pumpAndSettle();

    await tester.enterText(field('Code postal'), '75a0112345');
    expect(find.text('75011'), findsOneWidget);
  });

  testWidgets('shows an empty state if the cart is empty', (tester) async {
    await tester.pumpLocalized(const CheckoutScreen());
    await tester.pumpAndSettle();
    expect(find.text('Votre panier est vide.'), findsOneWidget);
  });
}
