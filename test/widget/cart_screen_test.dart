import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/ui/screens/cart_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// Montant rendu par `PriceTag` (deux segments de texte).
Finder price(String digits) => find.byWidgetPredicate(
  (widget) => widget is RichText && widget.text.toPlainText() == '$digits FCFA',
);

void main() {
  testWidgets('shows an empty state when the cart is empty', (tester) async {
    await tester.pumpLocalized(const CartScreen());
    expect(find.text('Votre panier est vide.'), findsOneWidget);
    expect(find.text('Commander'), findsNothing);
  });

  testWidgets('lists items, updates totals and delivery as quantities change', (
    tester,
  ) async {
    final container = await tester.pumpLocalized(const CartScreen());
    container.read(cartProvider.notifier).addProduct(pot);
    await tester.pumpAndSettle();

    expect(find.text('Marmite en inox'), findsOneWidget);
    // 14 000 FCFA + 2 000 FCFA de livraison.
    expect(find.text('2 000 FCFA'), findsOneWidget);
    expect(price('16 000'), findsOneWidget);
    expect(
      find.text('Plus que 36 000 FCFA pour la livraison offerte'),
      findsOneWidget,
    );

    for (var i = 0; i < 3; i++) {
      await tester.tap(
        find.byTooltip('Augmenter la quantité de Marmite en inox'),
      );
    }
    await tester.pumpAndSettle();

    // 4 × 14 000 FCFA = 56 000 FCFA : livraison offerte.
    expect(find.text('Offerte'), findsOneWidget);
    expect(price('56 000'), findsNWidgets(2));
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('clearing the cart asks for confirmation', (tester) async {
    final container = await tester.pumpLocalized(const CartScreen());
    container.read(cartProvider.notifier)
      ..addProduct(pot)
      ..addProduct(pagne);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Vider le panier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).items, hasLength(2));

    await tester.tap(find.byTooltip('Vider le panier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmer'));
    await tester.pumpAndSettle();
    expect(find.text('Votre panier est vide.'), findsOneWidget);
  });
}
