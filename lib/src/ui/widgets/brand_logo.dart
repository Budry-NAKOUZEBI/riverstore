import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo RiverStore : une pastille « fleuve » (deux vagues dorées) et le nom
/// en Bricolage Grotesque, « Store » en terracotta.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 26});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontFamily: AppTheme.displayFont,
      fontWeight: FontWeight.w800,
      fontSize: size * 0.92,
      letterSpacing: -0.6,
      color: colors.onSurface,
    );
    return Semantics(
      label: 'RiverStore',
      header: true,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size * 1.3,
            height: size * 1.3,
            decoration: BoxDecoration(
              color: AppTheme.river,
              borderRadius: BorderRadius.circular(size * 0.4),
            ),
            child: CustomPaint(painter: _WavesPainter()),
          ),
          SizedBox(width: size * 0.4),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'River'),
                TextSpan(
                  text: 'Store',
                  style: TextStyle(color: colors.secondary),
                ),
              ],
            ),
            style: style,
          ),
        ],
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.gold
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.09;
    for (final dy in const [0.42, 0.62]) {
      final y = size.height * dy;
      final path = Path()..moveTo(size.width * 0.2, y);
      path.cubicTo(
        size.width * 0.38,
        y - size.height * 0.14,
        size.width * 0.5,
        y + size.height * 0.14,
        size.width * 0.8,
        y - size.height * 0.02,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WavesPainter oldDelegate) => false;
}
