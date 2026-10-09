import 'package:flutter/material.dart';

/// Image réseau optimisée :
/// - décodée à la taille réellement affichée (`cacheWidth`) au lieu de la
///   résolution source, ce qui divise la mémoire GPU/RAM utilisée ;
/// - chargée uniquement quand le widget est construit (les grilles et listes
///   utilisent des builders paresseux) ;
/// - apparition en fondu sans saut de mise en page grâce à un fond réservé.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.semanticLabel});

  final String url;
  final String? semanticLabel;

  /// Largeur de décodage en pixels physiques, arrondie au palier de 100 px
  /// supérieur pour que des tailles voisines partagent la même entrée du
  /// cache d'images.
  static int? decodeWidthFor(double logicalWidth, double devicePixelRatio) {
    if (!logicalWidth.isFinite || logicalWidth <= 0) return null;
    const step = 100;
    final physical = (logicalWidth * devicePixelRatio).ceil();
    return ((physical + step - 1) ~/ step) * step;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Image.network(
            url,
            cacheWidth: decodeWidthFor(
              constraints.maxWidth,
              MediaQuery.devicePixelRatioOf(context),
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
            semanticLabel: semanticLabel,
            excludeFromSemantics: semanticLabel == null,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: child,
              );
            },
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: colors.outline,
              ),
            ),
          );
        },
      ),
    );
  }
}
