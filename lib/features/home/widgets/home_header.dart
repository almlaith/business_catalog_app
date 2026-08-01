import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/core/widgets/bidi_safe_text.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.business, required this.onBrowse, super.key});

  final BusinessConfig business;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = Directionality.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.dark
            ? AuroraGradients.heroDark
            : AuroraGradients.heroLight,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        boxShadow: AuroraShadows.glow(colorScheme.primary, opacity: 0.24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        child: Stack(
          children: [
            PositionedDirectional(
              end: -72,
              top: -58,
              child: _HeroLightBand(
                color: AuroraColors.cyanHighlight,
                width: 220,
                height: 74,
                angle: 0.52,
                opacity: 0.20,
              ),
            ),
            PositionedDirectional(
              start: textDirection == TextDirection.rtl ? null : -70,
              end: textDirection == TextDirection.rtl ? -70 : null,
              bottom: -92,
              child: _HeroLightBand(
                color: AuroraColors.coral,
                width: 240,
                height: 86,
                angle: -0.42,
                opacity: 0.14,
              ),
            ),
            PositionedDirectional(
              end: AppSpacing.lg,
              top: AppSpacing.lg,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: AuroraColors.success,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.l10n.available,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadii.xl),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: LocalAssetImage(
                            assetPath: business.logoAsset,
                            width: 68,
                            height: 68,
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: BidiSafeText(
                          business.businessName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            height: 1.02,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BidiSafeText(
                    business.shortDescription,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.38,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AuroraGradientButton(
                      onPressed: onBrowse,
                      icon: Icon(
                        textDirection == TextDirection.rtl
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(context.l10n.viewCatalog),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroLightBand extends StatelessWidget {
  const _HeroLightBand({
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
            borderRadius: BorderRadius.circular(AppRadii.pill),
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
