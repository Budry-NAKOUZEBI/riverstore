import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/ui/screens/catalog_screen.dart';
import 'package:riverstore/src/ui/widgets/catalog_filters.dart';
import 'package:riverstore/src/ui/widgets/product_card.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('shows a loader, then the product grid', (tester) async {
    final repository = FakeProductRepository()..gate = Completer<void>();
    await tester.pumpLocalized(
      const CatalogScreen(),
      productRepository: repository,
    );

    expect(find.text('Chargement du catalogue…'), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(ProductCard), findsNWidgets(4));
    expect(find.text('Casque audio'), findsOneWidget);
  });

  testWidgets('search is debounced and ignores accents', (tester) async {
    await tester.pumpLocalized(const CatalogScreen());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'ecran');
    await tester.pump(searchDebounce ~/ 2);
    expect(
      find.byType(ProductCard),
      findsNWidgets(4),
      reason: 'pas encore filtré',
    );

    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Écran incurvé'), findsOneWidget);
  });

  testWidgets('category chips filter and the empty state resets filters', (
    tester,
  ) async {
    await tester.pumpLocalized(const CatalogScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Maison'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'introuvable');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(
      find.text('Aucun produit ne correspond à votre recherche.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Réinitialiser les filtres'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(4));
    expect(find.widgetWithText(TextField, 'introuvable'), findsNothing);
  });

  testWidgets('an error offers to retry', (tester) async {
    final repository = FakeProductRepository()..error = Exception('offline');
    await tester.pumpLocalized(
      const CatalogScreen(),
      productRepository: repository,
    );
    await tester.pumpAndSettle();

    expect(find.text('Impossible de charger les produits.'), findsOneWidget);

    repository.error = null;
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.byType(ProductCard), findsNWidgets(4));
  });
}
