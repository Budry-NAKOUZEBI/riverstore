import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/cart_providers.dart';
import '../l10n_extensions.dart';
import 'product_image.dart';
import 'quantity_stepper.dart';

/// Ligne du panier. Elle n'écoute que sa propre entrée : modifier la
/// quantité d'un article ne reconstruit pas les autres lignes.
class CartItemTile extends ConsumerWidget {
  const CartItemTile({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(cartItemProvider(productId));
    if (item == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final notifier = ref.read(cartProvider.notifier);
    final product = item.product;
    final name = product.name.resolve(context.languageCode);

    void remove() {
      final quantity = item.quantity;
      notifier.removeProduct(productId);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.itemRemoved(name)),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => notifier.addProduct(product, quantity: quantity),
            ),
          ),
        );
    }

    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.removeItem(name)): remove,
      },
      child: Dismissible(
        key: ValueKey(productId),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => remove(),
        background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(22),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox.square(
                    dimension: 72,
                    child: ProductImage(url: product.thumbnailUrl),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.cartItemSubtitle(
                          context.formatPrice(product.price),
                          context.formatPrice(item.subtotal),
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      QuantityStepper(
                        quantity: item.quantity,
                        max: product.stock,
                        productName: name,
                        onIncrement: () => notifier.increment(productId),
                        onDecrement: () => notifier.decrement(productId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
