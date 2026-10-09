import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/order_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../theme/app_theme.dart';
import '../widgets/order_summary.dart';
import '../widgets/state_views.dart';
import '../widgets/wax_motif.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final order = ref.watch(orderByIdProvider(orderId));
    void backToCatalog() => context.go(AppRoutes.catalog);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) backToCatalog();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.orderConfirmedTitle),
        ),
        body: order == null
            ? EmptyState(
                icon: Icons.receipt_long_outlined,
                message: l10n.orderMissing,
                actionLabel: l10n.backToCatalog,
                onAction: backToCatalog,
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      WaxBanner(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: AppTheme.gold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 40,
                                color: AppTheme.riverDeep,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Semantics(
                              header: true,
                              child: Text(
                                l10n.orderConfirmedMessage(
                                  order.address.fullName.split(' ').first,
                                ),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${l10n.orderNumber(order.id)} · '
                              '${l10n.orderItemsCount(order.itemCount)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoBlock(
                                icon: Icons.location_on_outlined,
                                title: l10n.orderDeliveryTo,
                                body:
                                    '${order.address.fullName} · +242 ${order.address.phone}\n'
                                    '${order.address.street}\n'
                                    '${order.address.district}, ${order.address.city}',
                              ),
                              const SizedBox(height: 14),
                              _InfoBlock(
                                icon: Icons.account_balance_wallet_outlined,
                                title: l10n.orderPaidWith(
                                  order.paymentMethod.label(l10n),
                                ),
                                body: order.paymentMethod.hint(l10n),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(),
                              ),
                              OrderSummary(
                                pricing: order.pricing,
                                showFreeShippingHint: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: backToCatalog,
                        child: Text(l10n.continueShopping),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(body, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
