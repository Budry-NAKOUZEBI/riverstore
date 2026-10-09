import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/providers/favorites_providers.dart';
import 'package:riverstore/src/ui/widgets/product_card.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

Widget card(Product product, {VoidCallback? onTap}) => Scaffold(
  body: Center(
    child: SizedBox(
      width: 200,
      height: 320,
      child: ProductCard(product: product, onTap: onTap ?? () {}),
    ),
  ),
);

void main() {
  testWidgets('shows the localized name, rating and formatted price', (
    tester,
  ) async {
    await tester.pumpLocalized(card(headphones));
    expect(find.text('Casque audio'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('79,90 €'), findsOneWidget);
  });

  testWidgets('switches product name and price format in English', (
    tester,
  ) async {
    await tester.pumpLocalized(card(headphones), locale: const Locale('en'));
    expect(find.text('Headphones'), findsOneWidget);
    expect(find.text('€79.90'), findsOneWidget);
  });

  testWidgets('tapping the card opens details, buttons act independently', (
    tester,
  ) async {
    var opened = 0;
    final container = await tester.pumpLocalized(
      card(headphones, onTap: () => opened++),
    );

    await tester.tap(find.text('Casque audio'));
    expect(opened, 1);

    await tester.tap(find.byTooltip('Ajouter aux favoris'));
    await tester.pumpAndSettle();
    expect(container.read(isFavoriteProvider(headphones.id)), isTrue);
    expect(find.byTooltip('Retirer des favoris'), findsOneWidget);

    await tester.tap(find.byTooltip('Ajouter Casque audio au panier'));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).quantityOf(headphones.id), 1);
    expect(find.text('Casque audio ajouté au panier'), findsOneWidget);
    expect(opened, 1);
  });

  testWidgets('out-of-stock products show a badge and cannot be added', (
    tester,
  ) async {
    await tester.pumpLocalized(card(screen));
    expect(find.text('Rupture de stock'), findsOneWidget);
    final button = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.add_shopping_cart),
        matching: find.byType(IconButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('exposes a single descriptive semantics node for the card', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpLocalized(card(headphones));
    expect(
      find.bySemanticsLabel('Casque audio, 79,90 €, noté 4.7 sur 5'),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
