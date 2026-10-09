import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../providers/cart_providers.dart';
import '../../providers/product_providers.dart';
import '../l10n_extensions.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/favorite_toggle_button.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_stars.dart';
import '../widgets/state_views.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final product = ref.watch(productByIdProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetailTitle),
        actions: [FavoriteToggleButton(productId: productId)],
      ),
      body: product.when(
        data: (product) => _ProductDetailBody(product: product),
        loading: () => const LoadingView(),
        error: (error, _) => error is ProductNotFoundException
            ? EmptyState(icon: Icons.search_off, message: l10n.productNotFound)
            : ErrorView(
                message: l10n.catalogError,
                onRetry: () => ref.invalidate(productsProvider),
              ),
      ),
      bottomNavigationBar: product.hasValue
          ? _AddToCartBar(product: product.requireValue)
          : null,
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final name = product.name.resolve(context.languageCode);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: ProductImage(
                  url: product.imageUrl,
                  semanticLabel: l10n.productImageSemantics(name),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(name, style: theme.textTheme.headlineSmall),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                RatingStars(rating: product.rating, size: 20),
                const SizedBox(width: 12),
                Text(
                  product.category.label(l10n),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              context.formatPrice(product.priceInCents),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.inStock
                  ? l10n.inStockCount(product.stock)
                  : l10n.outOfStock,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: product.inStock
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.description.resolve(context.languageCode),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToCartBar extends ConsumerWidget {
  const _AddToCartBar({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final inCart = ref.watch(cartItemProvider(product.id))?.quantity ?? 0;
    final canAdd = product.inStock && inCart < product.stock;
    final name = product.name.resolve(context.languageCode);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (inCart > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(l10n.inCartCount(inCart)),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: canAdd
                    ? () {
                        ref.read(cartProvider.notifier).addProduct(product);
                        showCartSnackBar(context, l10n.addedToCart(name));
                      }
                    : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(
                  !product.inStock
                      ? l10n.outOfStock
                      : canAdd
                      ? l10n.addToCart
                      : l10n.stockLimitReached,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
