import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cart_providers.dart';
import '../../providers/favorites_providers.dart';
import '../../providers/user_providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final favoritesCount = ref.watch(favoritesProvider).length;
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: userAsync.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(user.avatarUrl),
              onBackgroundImageError: (_, __) {},
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
            ),
            Center(
              child: Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _ProfileRow(
                      label: 'Membre depuis',
                      value: _formatDate(user.memberSince),
                    ),
                    _ProfileRow(
                      label: 'Commandes passées',
                      value: '${user.totalOrders}',
                    ),
                    _ProfileRow(label: 'Favoris', value: '$favoritesCount'),
                    _ProfileRow(label: 'Articles au panier', value: '$cartCount'),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          message: '$error',
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
