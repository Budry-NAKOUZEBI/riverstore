import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/order_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../widgets/order_summary.dart';
import '../widgets/state_views.dart';

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
                    padding: const EdgeInsets.all(24),
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 96,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        header: true,
                        child: Text(
                          l10n.orderConfirmedMessage(
                            order.address.fullName.split(' ').first,
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.orderNumber(order.id)} · '
                        '${l10n.orderItemsCount(order.itemCount)}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.orderDeliveryTo,
                                style: theme.textTheme.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${order.address.fullName}\n'
                                '${order.address.street}\n'
                                '${order.address.postalCode} ${order.address.city}',
                              ),
                              const Divider(height: 24),
                              OrderSummary(
                                pricing: order.pricing,
                                showFreeShippingHint: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
