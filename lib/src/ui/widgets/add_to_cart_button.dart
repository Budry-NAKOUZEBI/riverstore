import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/product.dart';
import '../../providers/cart_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';

/// Ajoute un produit au panier et confirme l'action par une courte
/// animation. Le contrôleur d'animation est géré par `flutter_hooks`
/// (création et `dispose` automatiques, sans `StatefulWidget`).
class AddToCartButton extends HookConsumerWidget {
  const AddToCartButton({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 160),
    );
    final scale = useMemoized(
      () => Tween<double>(
        begin: 1,
        end: 1.2,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      [controller],
    );
    final justAdded = useState(false);
    final l10n = context.l10n;
    final name = product.name.resolve(context.languageCode);

    Future<void> onPressed() async {
      final added = ref.read(cartProvider.notifier).addProduct(product);
      showCartSnackBar(
        context,
        added ? l10n.addedToCart(name) : l10n.stockLimitReached,
      );
      if (!added) return;
      justAdded.value = true;
      await controller.forward();
      await controller.reverse();
      if (context.mounted) justAdded.value = false;
    }

    return ScaleTransition(
      scale: scale,
      child: IconButton.filled(
        tooltip: product.inStock
            ? l10n.addToCartTooltip(name)
            : l10n.outOfStock,
        onPressed: product.inStock ? onPressed : null,
        icon: Icon(justAdded.value ? Icons.check : Icons.add_shopping_cart),
      ),
    );
  }
}

/// Affiche une confirmation avec un raccourci vers le panier (si le
/// routeur est disponible).
void showCartSnackBar(BuildContext context, String message) {
  final router = GoRouter.maybeOf(context);
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: router == null
          ? null
          : SnackBarAction(
              label: context.l10n.viewCart,
              onPressed: () => router.go(AppRoutes.cart),
            ),
    ),
  );
}
