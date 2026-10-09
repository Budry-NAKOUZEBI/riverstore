import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/cart_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/order_summary.dart';
import '../widgets/state_views.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Ne se reconstruit que lorsque des lignes sont ajoutées ou retirées ;
    // les changements de quantité sont gérés par chaque ligne.
    final productIds = ref.watch(cartProductIdsProvider);
    final isEmpty = productIds.length == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        actions: [
          if (!isEmpty)
            IconButton(
              tooltip: l10n.clearCart,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              message: l10n.cartEmpty,
              actionLabel: l10n.startShopping,
              onAction: () => context.go(AppRoutes.catalog),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: productIds.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => CartItemTile(
                key: ValueKey(productIds[index]),
                productId: productIds[index],
              ),
            ),
      bottomNavigationBar: isEmpty ? null : const _CartFooter(),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCartConfirmTitle),
        content: Text(l10n.clearCartConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed ?? false) ref.read(cartProvider.notifier).clear();
  }
}

class _CartFooter extends ConsumerWidget {
  const _CartFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricing = ref.watch(cartPricingProvider);
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OrderSummary(pricing: pricing),
              const SizedBox(height: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.onSecondary,
                ),
                onPressed: () => context.go(AppRoutes.checkout),
                icon: const Icon(Icons.lock_outline),
                label: Text(context.l10n.checkout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
