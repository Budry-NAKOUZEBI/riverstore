import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/cart.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../providers/cart_providers.dart';
import '../../providers/product_providers.dart';
import '../l10n_extensions.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/favorite_toggle_button.dart';
import '../widgets/price_tag.dart';
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

    return product.when(
      data: (product) => Scaffold(
        body: _ProductDetailBody(product: product),
        bottomNavigationBar: _AddToCartBar(product: product),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.productDetailTitle)),
        body: const LoadingView(),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.productDetailTitle)),
        body: error is ProductNotFoundException
            ? EmptyState(
                icon: Icons.search_off,
                message: userMessageFor(error, l10n),
              )
            : ErrorView(
                message: userMessageFor(error, l10n),
                onRetry: () => ref.invalidate(productsProvider),
              ),
      ),
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
    final colors = theme.colorScheme;
    final name = product.name.resolve(context.languageCode);
    final width = MediaQuery.sizeOf(context).width;
    final buttonStyle = IconButton.styleFrom(
      backgroundColor: colors.surfaceContainerLowest.withValues(alpha: 0.94),
      foregroundColor: colors.onSurface,
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          expandedHeight: math.min(width, 460),
          backgroundColor: colors.surface,
          leading: Padding(
            padding: const EdgeInsets.all(4),
            child: BackButton(style: buttonStyle),
          ),
          actions: [
            FavoriteToggleButton(productId: product.id, onImage: true),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              child: ProductImage(
                url: product.imageUrl,
                semanticLabel: l10n.productImageSemantics(name),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Tag(
                          label: product.category.label(l10n),
                          background: colors.secondaryContainer,
                          foreground: colors.onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        _Tag(
                          label: product.inStock
                              ? l10n.inStockCount(product.stock)
                              : l10n.outOfStock,
                          background: product.inStock
                              ? colors.primaryContainer
                              : colors.errorContainer,
                          foreground: product.inStock
                              ? colors.onPrimaryContainer
                              : colors.onErrorContainer,
                        ),
                        const Spacer(),
                        RatingStars(rating: product.rating, size: 20),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Semantics(
                      header: true,
                      child: Text(name, style: theme.textTheme.headlineMedium),
                    ),
                    const SizedBox(height: 18),
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.detailDescription,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description.resolve(context.languageCode),
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${l10n.heroSubtitle} '
                              '${l10n.heroBadge(context.formatPrice(OrderPricing.freeShippingThreshold))}.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
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
    final colors = Theme.of(context).colorScheme;
    final inCart = ref.watch(cartItemProvider(product.id))?.quantity ?? 0;
    final canAdd = product.inStock && inCart < product.stock;
    final name = product.name.resolve(context.languageCode);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inCart > 0 ? l10n.inCartCount(inCart) : l10n.detailPrice,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(
                      height: 34,
                      child: PriceTag(amount: product.price, fontSize: 26),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.secondary,
                    foregroundColor: colors.onSecondary,
                  ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
