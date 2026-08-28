import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product.dart';
import '../../providers/cart_providers.dart';
import '../../providers/product_providers.dart';
import '../widgets/error_view.dart';
import '../widgets/favorite_toggle_button.dart';
import '../widgets/loading_view.dart';
import '../widgets/rating_stars.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail produit'),
        actions: [FavoriteToggleButton(productId: productId)],
      ),
      body: productAsync.when(
        data: (product) => _ProductDetailBody(product: product),
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          message: '$error',
          onRetry: () => ref.invalidate(productListProvider),
        ),
      ),
    );
  }
}

class _ProductDetailBody extends ConsumerWidget {
  const _ProductDetailBody({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.image_not_supported_outlined, size: 48),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        RatingStars(rating: product.rating, size: 20),
        const SizedBox(height: 12),
        Text(
          '${product.price.toStringAsFixed(2)} €',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          product.inStock ? '${product.stock} en stock' : 'Rupture de stock',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: product.inStock
                    ? Colors.green.shade700
                    : Theme.of(context).colorScheme.error,
              ),
        ),
        const SizedBox(height: 16),
        Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: product.inStock
              ? () {
                  ref.read(cartProvider.notifier).addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} ajouté au panier')),
                  );
                }
              : null,
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Ajouter au panier'),
        ),
      ],
    );
  }
}
