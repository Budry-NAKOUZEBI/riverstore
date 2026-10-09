import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../l10n_extensions.dart';
import 'add_to_cart_button.dart';
import 'favorite_toggle_button.dart';
import 'price_tag.dart';
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
    final colors = theme.colorScheme;
    final name = product.name.resolve(context.languageCode);
    final price = context.formatPrice(product.price);
    final rating = product.rating.toStringAsFixed(1);
    final nameStyle = theme.textTheme.titleSmall!.copyWith(height: 1.25);
    final nameHeight =
        MediaQuery.textScalerOf(context).scale(nameStyle.fontSize!) *
        nameStyle.height! *
        2;
    final semanticsLabel = [
      l10n.productCardSemantics(name, price, rating),
      if (!product.inStock) l10n.outOfStock,
    ].join(', ');

    return Material(
      color: colors.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
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
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ProductImage(url: product.thumbnailUrl),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: _Pill(
                                child: RatingStars(
                                  rating: product.rating,
                                  size: 14,
                                ),
                              ),
                            ),
                            if (!product.inStock)
                              Positioned(
                                left: 8,
                                bottom: 8,
                                child: _Pill(
                                  dark: true,
                                  child: Text(l10n.outOfStock),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.category.label(l10n).toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Hauteur de deux lignes réservée : les cartes
                          // d'une même rangée restent alignées.
                          SizedBox(
                            height: nameHeight,
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: nameStyle,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Laisse la place au bouton panier, en bas à droite.
                          Padding(
                            padding: const EdgeInsets.only(right: 48),
                            child: SizedBox(
                              height: 28,
                              child: PriceTag(amount: product.price),
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
          // Boutons posés au-dessus de la zone cliquable : ils restent des
          // nœuds d'accessibilité distincts avec leur propre libellé.
          Positioned(
            top: 8,
            right: 8,
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

class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.dark = false});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xE6201A14)
            : colors.surfaceContainerLowest.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: dark ? Colors.white : colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
          child: child,
        ),
      ),
    );
  }
}
