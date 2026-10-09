import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Motif géométrique inspiré des pagnes wax : anneaux concentriques dorés,
/// graines terracotta et points crème, sur une trame décalée.
///
/// Dessiné en vectoriel (net à toutes les densités, aucun asset à charger)
/// et isolé dans un [RepaintBoundary] : il n'est peint qu'une fois.
class WaxMotif extends StatelessWidget {
  const WaxMotif({super.key, this.opacity = 0.22, this.tile = 56});

  final double opacity;
  final double tile;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _WaxPainter(opacity: opacity, tile: tile),
        size: Size.infinite,
      ),
    );
  }
}

class _WaxPainter extends CustomPainter {
  _WaxPainter({required this.opacity, required this.tile});

  final double opacity;
  final double tile;

  @override
  void paint(Canvas canvas, Size size) {
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tile * 0.045
      ..color = AppTheme.gold.withValues(alpha: opacity * 2.2);
    final seed = Paint()
      ..color = AppTheme.laterite.withValues(alpha: opacity * 2.4);
    final dot = Paint()
      ..color = const Color(0xFFFBF7F0).withValues(alpha: opacity * 2);

    final rows = (size.height / tile).ceil() + 1;
    final cols = (size.width / tile).ceil() + 1;
    for (var row = 0; row < rows; row++) {
      final shift = row.isOdd ? tile / 2 : 0.0;
      for (var col = -1; col < cols; col++) {
        final center = Offset(col * tile + shift, row * tile);
        for (final factor in const [0.34, 0.22, 0.1]) {
          canvas.drawCircle(center, tile * factor, ring);
        }
        // Graine en amande entre deux anneaux.
        canvas
          ..save()
          ..translate(center.dx + tile / 2, center.dy)
          ..rotate(math.pi / 4)
          ..drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: tile * 0.26,
              height: tile * 0.13,
            ),
            seed,
          )
          ..restore();
        canvas.drawCircle(
          center.translate(tile / 4, tile / 2),
          tile * 0.04,
          dot,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WaxPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.tile != tile;
}

/// Bandeau de marque : fond vert fleuve, motif wax et dégradé qui garantit
/// la lisibilité (et le contraste) du texte posé à gauche.
class WaxBanner extends StatelessWidget {
  const WaxBanner({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppTheme.river),
        child: Stack(
          children: [
            const Positioned.fill(child: WaxMotif()),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppTheme.riverDeep,
                      Color(0x8806332C),
                      Color(0x0006332C),
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: IconTheme.merge(
                  data: const IconThemeData(color: Colors.white),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
