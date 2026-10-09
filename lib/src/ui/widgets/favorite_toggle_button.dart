import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/favorites_providers.dart';
import '../l10n_extensions.dart';
import 'round_icon_button.dart';

class FavoriteToggleButton extends ConsumerWidget {
  const FavoriteToggleButton({
    super.key,
    required this.productId,
    this.onImage = false,
  });

  final String productId;

  /// Variante avec fond, lisible lorsqu'elle est superposée à une photo.
  final bool onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // N'écoute que ce produit : basculer un autre favori ne reconstruit pas
    // ce bouton.
    final isFavorite = ref.watch(isFavoriteProvider(productId));
    final l10n = context.l10n;
    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        key: ValueKey(isFavorite),
        color: isFavorite ? const Color(0xFFC62828) : null,
      ),
    );
    void onPressed() => ref.read(favoritesProvider.notifier).toggle(productId);
    final tooltip = isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites;

    final colors = Theme.of(context).colorScheme;
    if (onImage) {
      return RoundIconButton(
        label: tooltip,
        toggled: isFavorite,
        onPressed: onPressed,
        background: colors.surfaceContainerLowest.withValues(alpha: 0.94),
        foreground: colors.onSurface,
        icon: icon,
      );
    }
    return Semantics(
      toggled: isFavorite,
      child: IconButton(tooltip: tooltip, onPressed: onPressed, icon: icon),
    );
  }
}
