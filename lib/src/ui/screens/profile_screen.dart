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
import '../widgets/state_views.dart';

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
    const avatarRadius = 48.0;
    final avatarPixels =
        (avatarRadius * 2 * MediaQuery.devicePixelRatioOf(context)).round();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Semantics(
            image: true,
            label: l10n.avatarSemantics(user.name),
            child: CircleAvatar(
              radius: avatarRadius,
              // Avatar décodé à sa taille d'affichage.
              foregroundImage: ResizeImage(
                NetworkImage(user.avatarUrl),
                width: avatarPixels,
              ),
              onForegroundImageError: (_, _) {},
              child: Text(
                user.name.split(' ').map((part) => part[0]).take(2).join(),
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.memberSince(user.memberSince),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _StatTile(
              label: l10n.statOrders,
              value: user.totalOrders + orders.length,
            ),
            const SizedBox(width: 12),
            _StatTile(label: l10n.statFavorites, value: favoritesCount),
            const SizedBox(width: 12),
            _StatTile(label: l10n.statCart, value: cartCount),
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(l10n.orderNumber(order.id)),
              subtitle: Text(l10n.orderItemsCount(order.itemCount)),
              trailing: Text(context.formatPrice(order.pricing.totalInCents)),
            ),
        const Divider(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.settings_outlined),
          title: Text(l10n.settingsTitle),
          subtitle: Text(l10n.settingsSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

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
                Text(
                  '$value',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
