import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:flutter/material.dart';

class AuroraBackground extends StatelessWidget {
  const AuroraBackground({
    required this.child,
    this.topGlow = true,
    this.bottomSafeGlow = false,
    super.key,
  });

  final Widget child;
  final bool topGlow;
  final bool bottomSafeGlow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainerLowest),
      child: Stack(
        children: [
          if (topGlow) ...[
            PositionedDirectional(
              top: -112,
              start: -80,
              child: _AuroraLightWash(
                color: colorScheme.primary,
                width: 320,
                height: 140,
                angle: -0.28,
                opacity: isDark ? 0.26 : 0.16,
              ),
            ),
            PositionedDirectional(
              top: 12,
              end: -104,
              child: _AuroraLightWash(
                color: colorScheme.secondary,
                width: 280,
                height: 118,
                angle: 0.34,
                opacity: isDark ? 0.20 : 0.13,
              ),
            ),
          ],
          if (bottomSafeGlow)
            PositionedDirectional(
              bottom: -120,
              end: -90,
              child: _AuroraLightWash(
                color: AuroraColors.coral,
                width: 280,
                height: 118,
                angle: -0.24,
                opacity: isDark ? 0.13 : 0.09,
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class _AuroraLightWash extends StatelessWidget {
  const _AuroraLightWash({
    required this.color,
    required this.width,
    required this.height,
    required this.angle,
    required this.opacity,
  });

  final Color color;
  final double width;
  final double height;
  final double angle;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0),
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
