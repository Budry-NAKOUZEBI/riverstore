import 'package:flutter/material.dart';

import '../l10n_extensions.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.productName,
    required this.onIncrement,
    required this.onDecrement,
    this.max,
  });

  final int quantity;
  final String productName;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  /// Quantité maximale (stock) ; le bouton « + » est désactivé au-delà.
  final int? max;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canIncrement = max == null || quantity < max!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.decreaseQuantity(productName),
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Semantics(
          liveRegion: true,
          label: l10n.quantitySemantics(quantity),
          child: ExcludeSemantics(
            child: SizedBox(
              width: 24,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.increaseQuantity(productName),
          onPressed: canIncrement ? onIncrement : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
