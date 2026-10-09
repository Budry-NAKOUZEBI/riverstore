import 'package:flutter/material.dart';

/// Bouton rond léger pour les éléments répétés en grande quantité (cartes
/// de la grille). Un `IconButton` Material 3 résout des dizaines de
/// propriétés d'état et embarque un tooltip ; ici on garde l'essentiel :
/// zone tactile de 48 dp, libellé d'accessibilité, effet d'encre.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
    this.toggled,
  });

  static const tapTarget = 48.0;
  static const diameter = 40.0;

  final Widget icon;

  /// Libellé lu par les lecteurs d'écran.
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;

  /// État activé/désactivé (bouton bascule), `null` pour un bouton simple.
  final bool? toggled;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: enabled,
      toggled: toggled,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onPressed,
        radius: tapTarget / 2,
        child: SizedBox.square(
          dimension: tapTarget,
          child: Center(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: enabled
                    ? background
                    : colors.onSurface.withValues(alpha: 0.12),
              ),
              child: SizedBox.square(
                dimension: diameter,
                child: IconTheme.merge(
                  data: IconThemeData(
                    size: 22,
                    color: enabled
                        ? foreground
                        : colors.onSurface.withValues(alpha: 0.38),
                  ),
                  child: Center(child: icon),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
