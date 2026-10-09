import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/ui/screens/cart_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('shows an empty state when the cart is empty', (tester) async {
    await tester.pumpLocalized(const CartScreen());
    expect(find.text('Votre panier est vide.'), findsOneWidget);
    expect(find.text('Commander'), findsNothing);
  });

  testWidgets('lists items, updates totals and shipping as quantities change', (
    tester,
  ) async {
    final container = await tester.pumpLocalized(const CartScreen());
    container.read(cartProvider.notifier).addProduct(lamp);
    await tester.pumpAndSettle();

    expect(find.text('Lampe de bureau'), findsOneWidget);
    // 24,90 € + 4,90 € de livraison.
    expect(find.text('29,80 €'), findsOneWidget);
    expect(
      find.text('Plus que 25,10 € pour la livraison offerte'),
      findsOneWidget,
    );

    await tester.tap(
      find.byTooltip('Augmenter la quantité de Lampe de bureau'),
    );
    await tester.tap(
      find.byTooltip('Augmenter la quantité de Lampe de bureau'),
    );
    await tester.pumpAndSettle();

    // 3 × 24,90 € = 74,70 € : livraison offerte.
    expect(find.text('Offerte'), findsOneWidget);
    expect(find.text('74,70 €'), findsWidgets);
  });

  testWidgets('clearing the cart asks for confirmation', (tester) async {
    final container = await tester.pumpLocalized(const CartScreen());
    container.read(cartProvider.notifier)
      ..addProduct(lamp)
      ..addProduct(headphones);
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
