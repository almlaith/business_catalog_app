import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/app_pressable.dart';
import 'package:business_catalog_app/core/widgets/bidi_safe_text.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.currencyCode,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final Product product;
  final String currencyCode;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: AuroraShadows.card(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: AppPressable(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: compact ? 1.72 : 1.10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product-image-${product.id}',
                      child: LocalAssetImage(
                        assetPath: product.imageAsset,
                        width: double.infinity,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.18),
                          ],
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: AppSpacing.sm,
                      top: AppSpacing.sm,
                      child: _AvailabilityPill(
                        isAvailable: product.isAvailable,
                      ),
                    ),
                    if (product.oldPrice != null &&
                        product.oldPrice! > product.price)
                      PositionedDirectional(
                        end: AppSpacing.sm,
                        top: AppSpacing.sm,
                        child: _PromoPill(label: context.l10n.featuredSection),
                      ),
                    if (!product.isAvailable)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.42),
                          ),
                          child: Center(
                            child: _UnavailableOverlay(
                              label: context.l10n.unavailable,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textScale = MediaQuery.textScalerOf(context).scale(1);
                    final roomy =
                        constraints.maxHeight > 116 && textScale < 1.25;
                    final showDescription = !compact && roomy;

                    return Padding(
                      padding: EdgeInsets.all(roomy ? AppSpacing.md : 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BidiSafeText(
                            product.name,
                            maxLines: roomy ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.08,
                            ),
                          ),
                          if (showDescription) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Flexible(
                              child: BidiSafeText(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.28,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          _ProductPrice(
                            price: product.price,
                            oldPrice: product.oldPrice,
                            currencyCode: currencyCode,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityPill extends StatelessWidget {
  const _AvailabilityPill({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final label = isAvailable
        ? context.l10n.available
        : context.l10n.unavailable;
    final accent = isAvailable ? AuroraColors.success : AuroraColors.error;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: accent.withValues(alpha: 0.58)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAvailable ? Icons.check_circle_rounded : Icons.block_rounded,
              color: accent,
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoPill extends StatelessWidget {
  const _PromoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AuroraGradients.primary,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: AppIconSizes.sm,
          semanticLabel: label,
        ),
      ),
    );
  }
}

class _UnavailableOverlay extends StatelessWidget {
  const _UnavailableOverlay({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AuroraColors.error.withValues(alpha: 0.42)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  const _ProductPrice({
    required this.price,
    required this.oldPrice,
    required this.currencyCode,
  });

  final double price;
  final double? oldPrice;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oldPrice = this.oldPrice;

    return Wrap(
      spacing: 8,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        BidiSafeText(
          formatCurrency(price, currencyCode: currencyCode),
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        if (oldPrice != null && oldPrice > price)
          BidiSafeText(
            formatCurrency(oldPrice, currencyCode: currencyCode),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 2,
            ),
          ),
      ],
    );
  }
}
