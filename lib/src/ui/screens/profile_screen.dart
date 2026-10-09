import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/user_profile.dart';
import '../../providers/cart_providers.dart';
import '../../providers/favorites_providers.dart';
import '../../providers/order_providers.dart';
import '../../providers/user_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../theme/app_theme.dart';
import '../widgets/state_views.dart';
import '../widgets/wax_motif.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go(AppRoutes.settings),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: user.when(
        data: (user) => _ProfileBody(user: user),
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.catalogError,
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final orders = ref.watch(orderHistoryProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final cartCount = ref.watch(cartItemCountProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        WaxBanner(
          child: Row(
            children: [
              Semantics(
                label: l10n.avatarSemantics(user.name),
                excludeSemantics: true,
                child: Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Text(
                    user.initials,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.riverDeep,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.profileContact('+242 ${user.phone}', user.city),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.memberSince(user.memberSince),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _StatTile(
              icon: Icons.receipt_long_outlined,
              label: l10n.statOrders,
              value: user.totalOrders + orders.length,
            ),
            const SizedBox(width: 12),
            _StatTile(
              icon: Icons.favorite_border,
              label: l10n.statFavorites,
              value: favoritesCount,
            ),
            const SizedBox(width: 12),
            _StatTile(
              icon: Icons.shopping_bag_outlined,
              label: l10n.statCart,
              value: cartCount,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(l10n.recentOrders, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        if (orders.isEmpty)
          Text(l10n.noRecentOrders, style: theme.textTheme.bodyMedium)
        else
          for (final order in orders)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(l10n.orderNumber(order.id)),
                subtitle: Text(l10n.orderItemsCount(order.itemCount)),
                trailing: Text(
                  context.formatPrice(order.pricing.total),
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.settingsTitle),
            subtitle: Text(l10n.settingsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(AppRoutes.settings),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(height: 6),
                Text('$value', style: theme.textTheme.headlineSmall),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
