import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/ui/widgets/quantity_stepper.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('calls back on +/- and disables + at the stock limit', (
    tester,
  ) async {
    var increments = 0;
    var decrements = 0;
    Widget stepper(int quantity) => Scaffold(
      body: QuantityStepper(
        quantity: quantity,
        max: 3,
        productName: 'Lampe',
        onIncrement: () => increments++,
        onDecrement: () => decrements++,
      ),
    );

    await tester.pumpLocalized(stepper(2));
    await tester.tap(find.byTooltip('Augmenter la quantité de Lampe'));
    await tester.tap(find.byTooltip('Diminuer la quantité de Lampe'));
    expect((increments, decrements), (1, 1));

    await tester.pumpLocalized(stepper(3));
    await tester.tap(find.byTooltip('Augmenter la quantité de Lampe'));
    expect(increments, 1, reason: 'le bouton + est désactivé au maximum');
  });

  testWidgets('announces the quantity to screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpLocalized(
      Scaffold(
        body: QuantityStepper(
          quantity: 2,
          productName: 'Lampe',
          onIncrement: () {},
          onDecrement: () {},
        ),
      ),
    );
    expect(find.bySemanticsLabel('Quantité : 2'), findsOneWidget);
    semantics.dispose();
  });
}
