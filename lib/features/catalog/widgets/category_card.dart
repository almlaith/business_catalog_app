import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/widgets/app_pressable.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category, required this.onTap, super.key});

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 164,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          boxShadow: AuroraShadows.card(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: AppPressable(
            onTap: onTap,
            child: Stack(
              children: [
                Positioned.fill(
                  child: LocalAssetImage(
                    assetPath: category.imageAsset,
                    width: double.infinity,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.04),
                          Colors.black.withValues(alpha: 0.74),
                        ],
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: AppSpacing.md,
                  end: AppSpacing.md,
                  top: AppSpacing.md,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AuroraGradients.primary,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: const SizedBox(width: 38, height: 5),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: AppSpacing.md,
                  end: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              height: 1.06,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        category.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
