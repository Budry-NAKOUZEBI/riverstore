import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/filter_providers.dart';
import '../../providers/product_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/product_card.dart';
import '../widgets/sort_filter_bar.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('RiverStore')),
      body: Column(
        children: [
          const SortFilterBar(),
          const Divider(height: 1),
          Expanded(
            child: filteredProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    message: 'Aucun produit ne correspond à votre recherche.',
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(productId: product.id),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const LoadingView(label: 'Chargement du catalogue…'),
              error: (error, stackTrace) => ErrorView(
                message: 'Impossible de charger les produits.\n$error',
                onRetry: () => ref.invalidate(productListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
