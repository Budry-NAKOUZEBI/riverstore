import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import 'product_card.dart';

/// Grille responsive et paresseuse (sliver) : seules les cartes visibles,
/// plus une petite marge, sont construites, et donc seules leurs images
/// sont téléchargées et décodées.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.58,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            key: ValueKey(product.id),
            product: product,
            onTap: () => onProductTap(product),
          );
        },
      ),
    );
  }
}
