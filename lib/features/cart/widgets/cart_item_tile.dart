import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/cart/domain/cart_item.dart';
import 'package:business_catalog_app/features/cart/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    required this.item,
    required this.currencyCode,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final String currencyCode;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalAssetImage(
            assetPath: item.product.imageAsset,
            width: 92,
            height: 108,
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      tooltip: context.l10n.removeItem,
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: AuroraColors.coral,
                      style: IconButton.styleFrom(
                        backgroundColor: AuroraColors.coral.withValues(
                          alpha: 0.10,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  formatCurrency(
                    item.product.price,
                    currencyCode: currencyCode,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    QuantityStepper(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    AnimatedSwitcher(
                      duration: AppDurations.fast,
                      child: Text(
                        formatCurrency(
                          item.lineTotal,
                          currencyCode: currencyCode,
                        ),
                        key: ValueKey(item.lineTotalCents),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
