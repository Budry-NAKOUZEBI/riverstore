import 'package:flutter/material.dart';

import '../l10n_extensions.dart';
import '../theme/app_theme.dart';

/// Prix mis en valeur : montant en Bricolage Grotesque, devise plus petite.
/// Réduit sa taille plutôt que de déborder (`120 000 FCFA` dans une carte
/// étroite) et s'annonce en entier aux lecteurs d'écran.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.amount,
    this.fontSize = 18,
    this.color,
  });

  final int amount;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final formatted = context.formatPrice(amount);
    final digits = formatted.substring(0, formatted.lastIndexOf(' '));
    final color = this.color ?? Theme.of(context).colorScheme.primary;
    return Semantics(
      label: formatted,
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: digits),
              TextSpan(
                text: ' FCFA',
                style: TextStyle(
                  fontFamily: AppTheme.bodyFont,
                  fontSize: fontSize * 0.55,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          maxLines: 1,
          style: TextStyle(
            fontFamily: AppTheme.displayFont,
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}
