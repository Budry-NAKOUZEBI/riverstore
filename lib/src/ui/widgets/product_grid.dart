import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import 'product_card.dart';

/// Grille responsive et paresseuse : seules les cartes visibles (plus une
/// petite marge) sont construites, et donc seules leurs images sont
/// téléchargées et décodées.
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
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.64,
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
    );
  }
}
