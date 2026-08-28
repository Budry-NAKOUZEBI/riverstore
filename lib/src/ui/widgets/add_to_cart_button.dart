import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product.dart';
import '../../providers/cart_providers.dart';

/// Bouton d'ajout au panier avec une courte animation de confirmation
/// (bonus demandé dans le cahier des charges).
class AddToCartButton extends ConsumerStatefulWidget {
  const AddToCartButton({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    lowerBound: 0,
    upperBound: 0.25,
  );

  bool _justAdded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    ref.read(cartProvider.notifier).addProduct(widget.product);
    setState(() => _justAdded = true);
    await _controller.forward();
    await _controller.reverse();
    if (mounted) setState(() => _justAdded = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: 1 + _controller.value, child: child);
      },
      child: IconButton.filled(
        onPressed: _handleTap,
        icon: Icon(_justAdded ? Icons.check : Icons.add_shopping_cart),
      ),
    );
  }
}
