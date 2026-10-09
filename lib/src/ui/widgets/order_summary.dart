import 'package:flutter/material.dart';

import '../../data/models/cart.dart';
import '../l10n_extensions.dart';

/// Récapitulatif sous-total / livraison / total, partagé entre le panier,
/// le checkout et la confirmation.
class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.pricing,
    this.showFreeShippingHint = true,
  });

  final OrderPricing pricing;
  final bool showFreeShippingHint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final remaining = pricing.remainingForFreeShippingInCents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Row(
          label: l10n.subtotal,
          value: context.formatPrice(pricing.subtotalInCents),
        ),
        _Row(
          label: l10n.shipping,
          value: pricing.shippingInCents == 0
              ? l10n.shippingFree
              : context.formatPrice(pricing.shippingInCents),
        ),
        const Divider(),
        _Row(
          label: l10n.total,
          value: context.formatPrice(pricing.totalInCents),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showFreeShippingHint &&
            remaining > 0 &&
            pricing.subtotalInCents > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.freeShippingHint(context.formatPrice(remaining)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.style});

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.bodyLarge;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(child: Text(label, style: textStyle)),
            Text(value, style: textStyle),
          ],
        ),
      ),
    );
  }
}
