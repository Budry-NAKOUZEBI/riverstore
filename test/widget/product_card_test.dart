import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/providers/favorites_providers.dart';
import 'package:riverstore/src/ui/widgets/product_card.dart';
import 'package:riverstore/src/ui/widgets/round_icon_button.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

Finder roundButton(String label) => find.byWidgetPredicate(
  (widget) => widget is RoundIconButton && widget.label == label,
);

Widget card(Product product, {VoidCallback? onTap}) => Scaffold(
  body: Center(
    child: SizedBox(
      width: 200,
      height: 330,
      child: ProductCard(product: product, onTap: onTap ?? () {}),
    ),
  ),
);

/// Le prix est rendu en deux segments (montant + « FCFA »).
Finder priceText(String digits) => find.byWidgetPredicate(
  (widget) =>
      widget is RichText && widget.text.toPlainText().startsWith(digits),
);

void main() {
  testWidgets('shows the localized name, category, rating and FCFA price', (
    tester,
  ) async {
    await tester.pumpLocalized(card(pagne));
    expect(find.text('Pagne wax'), findsOneWidget);
    expect(find.text('MODE & PAGNES'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
    expect(priceText('18 000 FCFA'), findsOneWidget);
  });

  testWidgets('switches name, category and number format in English', (
    tester,
  ) async {
    await tester.pumpLocalized(card(pagne), locale: const Locale('en'));
    expect(find.text('Wax print fabric'), findsOneWidget);
    expect(find.text('FASHION & WAX'), findsOneWidget);
    expect(priceText('18,000 FCFA'), findsOneWidget);
  });

  testWidgets('tapping the card opens details, buttons act independently', (
    tester,
  ) async {
    var opened = 0;
    final container = await tester.pumpLocalized(
      card(pagne, onTap: () => opened++),
    );

    await tester.tap(find.text('Pagne wax'));
    expect(opened, 1);

    await tester.tap(roundButton('Ajouter aux favoris'));
    await tester.pumpAndSettle();
    expect(container.read(isFavoriteProvider(pagne.id)), isTrue);
    expect(roundButton('Retirer des favoris'), findsOneWidget);

    await tester.tap(roundButton('Ajouter Pagne wax au panier'));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).quantityOf(pagne.id), 1);
    expect(find.text('Pagne wax ajouté au panier'), findsOneWidget);
    expect(opened, 1);
  });

  testWidgets('out-of-stock products show a badge and cannot be added', (
    tester,
  ) async {
    await tester.pumpLocalized(card(solarKit));
    expect(find.text('Rupture de stock'), findsOneWidget);
    final button = tester.widget<RoundIconButton>(
      roundButton('Rupture de stock'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('exposes a single descriptive semantics node for the card', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpLocalized(card(pagne));
    expect(
      find.bySemanticsLabel('Pagne wax, 18 000 FCFA, noté 4.7 sur 5'),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
