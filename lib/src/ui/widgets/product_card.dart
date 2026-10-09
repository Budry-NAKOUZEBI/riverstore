import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../l10n_extensions.dart';
import 'add_to_cart_button.dart';
import 'favorite_toggle_button.dart';
import 'product_image.dart';
import 'rating_stars.dart';

/// Carte produit de la grille. Widget sans état : seuls les boutons favori
/// et panier écoutent Riverpod, la carte elle-même ne se reconstruit jamais
/// lors d'un changement de panier ou de favoris.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final name = product.name.resolve(context.languageCode);
    final price = context.formatPrice(product.priceInCents);
    final rating = product.rating.toStringAsFixed(1);
    final semanticsLabel = [
      l10n.productCardSemantics(name, price, rating),
      if (!product.inStock) l10n.outOfStock,
    ].join(', ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Semantics(
            container: true,
            button: true,
            label: semanticsLabel,
            onTapHint: l10n.productCardHint,
            excludeSemantics: true,
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ProductImage(url: product.thumbnailUrl),
                        if (!product.inStock)
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Chip(
                              label: Text(l10n.outOfStock),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        // Laisse la place au bouton panier, en bas à droite.
                        Padding(
                          padding: const EdgeInsets.only(right: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingStars(rating: product.rating),
                              const SizedBox(height: 2),
                              Text(
                                price,
                                maxLines: 1,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Boutons posés au-dessus de la zone cliquable : ils restent des
          // nœuds d'accessibilité distincts avec leur propre libellé.
          Positioned(
            top: 4,
            right: 4,
            child: FavoriteToggleButton(productId: product.id, onImage: true),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: AddToCartButton(product: product),
          ),
        ],
      ),
    );
  }
}
