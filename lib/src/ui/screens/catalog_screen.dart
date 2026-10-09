import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/cart.dart';
import '../../providers/filter_providers.dart';
import '../../providers/product_providers.dart';
import '../../providers/user_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/catalog_filters.dart';
import '../widgets/product_grid.dart';
import '../widgets/state_views.dart';
import '../widgets/wax_motif.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  /// Clé de la zone de défilement (utilisée par les tests de performance).
  static const scrollKey = Key('catalog-scroll');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandLogo(),
        actions: const [SortMenuButton(), SizedBox(width: 8)],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(productsProvider.future),
        child: const CustomScrollView(
          key: scrollKey,
          slivers: [
            SliverToBoxAdapter(child: _Hero()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: CatalogSearchField(),
              ),
            ),
            SliverToBoxAdapter(child: CategoryChips()),
            _CatalogBody(),
          ],
        ),
      ),
    );
  }
}

/// Bandeau d'accueil, masqué pendant une recherche pour laisser la place
/// aux résultats.
class _Hero extends ConsumerWidget {
  const _Hero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(filterProvider.select((f) => f.isDefault));
    if (!visible) return const SizedBox(height: 8);
    final firstName = ref.watch(
      userProfileProvider.select((u) => u.value?.firstName),
    );
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: WaxBanner(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstName == null
                  ? l10n.heroGreeting
                  : l10n.greetingUser(firstName),
              style: textTheme.titleMedium?.copyWith(
                color: AppTheme.gold,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Semantics(
                header: true,
                child: Text(
                  l10n.heroTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                l10n.heroSubtitle,
                style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.gold,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 18,
                      color: AppTheme.riverDeep,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.heroBadge(
                          context.formatPrice(
                            OrderPricing.freeShippingThreshold,
                          ),
                        ),
                        style: textTheme.labelLarge?.copyWith(
                          color: AppTheme.riverDeep,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogBody extends ConsumerWidget {
  const _CatalogBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final products = ref.watch(filteredProductsProvider(context.languageCode));

    return products.when(
      data: (items) {
        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.search_off,
              message: l10n.catalogEmpty,
              actionLabel: l10n.resetFilters,
              onAction: ref.read(filterProvider.notifier).reset,
            ),
          );
        }
        return ProductGrid(
          products: items,
          onProductTap: (product) =>
              context.go(AppRoutes.catalogProduct(product.id)),
        );
      },
      loading: () => SliverFillRemaining(
        hasScrollBody: false,
        child: LoadingView(label: l10n.catalogLoading),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(
          message: userMessageFor(error, l10n),
          onRetry: () => ref.invalidate(productsProvider),
        ),
      ),
    );
  }
}
