import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/favorites_providers.dart';
import '../../providers/product_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../widgets/product_grid.dart';
import '../widgets/state_views.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: favorites.when(
        data: (products) => products.isEmpty
            ? EmptyState(
                icon: Icons.favorite_border,
                message: l10n.favoritesEmpty,
                actionLabel: l10n.startShopping,
                onAction: () => context.go(AppRoutes.catalog),
              )
            : ProductGrid(
                products: products,
                onProductTap: (product) =>
                    context.go(AppRoutes.favoriteProduct(product.id)),
              ),
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.catalogError,
          onRetry: () => ref.invalidate(productsProvider),
        ),
      ),
    );
  }
}
