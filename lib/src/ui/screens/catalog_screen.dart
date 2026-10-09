import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/filter_providers.dart';
import '../../providers/product_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../widgets/catalog_filters.dart';
import '../widgets/product_grid.dart';
import '../widgets/state_views.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: const [SortMenuButton()],
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: CatalogSearchField(),
          ),
          CategoryChips(),
          Expanded(child: _CatalogBody()),
        ],
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
          return EmptyState(
            icon: Icons.search_off,
            message: l10n.catalogEmpty,
            actionLabel: l10n.resetFilters,
            onAction: ref.read(filterProvider.notifier).reset,
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(productsProvider.future),
          child: ProductGrid(
            products: items,
            onProductTap: (product) =>
                context.go(AppRoutes.catalogProduct(product.id)),
          ),
        );
      },
      loading: () => LoadingView(label: l10n.catalogLoading),
      error: (error, _) => ErrorView(
        message: l10n.catalogError,
        onRetry: () => ref.invalidate(productsProvider),
      ),
    );
  }
}
