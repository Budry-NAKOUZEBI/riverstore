import 'package:flutter/material.dart';

import '../../data/models/cart.dart';
import '../l10n_extensions.dart';
import 'price_tag.dart';

/// Récapitulatif sous-total / livraison / total, partagé entre le panier,
/// le checkout et la confirmation. Affiche la progression vers la
/// livraison offerte.
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
    final remaining = pricing.remainingForFreeShipping;
    final showHint =
        showFreeShippingHint && remaining > 0 && pricing.subtotal > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHint) ...[
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 18,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.freeShippingHint(context.formatPrice(remaining)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: pricing.subtotal / OrderPricing.freeShippingThreshold,
                minHeight: 6,
                color: theme.colorScheme.secondary,
                backgroundColor: theme.colorScheme.secondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        _Row(
          label: l10n.subtotal,
          value: context.formatPrice(pricing.subtotal),
        ),
        _Row(
          label: l10n.shipping,
          value: pricing.shipping == 0
              ? l10n.shippingFree
              : context.formatPrice(pricing.shipping),
          highlight: pricing.shipping == 0 && pricing.subtotal > 0,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        MergeSemantics(
          child: Row(
            children: [
              Expanded(
                child: Text(l10n.total, style: theme.textTheme.titleLarge),
              ),
              SizedBox(
                height: 34,
                child: PriceTag(amount: pricing.total, fontSize: 26),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label, style: style)),
            Text(
              value,
              style: style?.copyWith(
                fontWeight: FontWeight.w700,
                color: highlight ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
