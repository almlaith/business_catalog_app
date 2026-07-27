import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:flutter/material.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({
    required this.cart,
    required this.currencyCode,
    super.key,
  });

  final CartState cart;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AuroraCard(
      useGradientBorder: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AuroraIconContainer(icon: Icons.receipt_long_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l10n.orderSummary,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final item in cart.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  formatCurrency(item.lineTotal, currencyCode: currencyCode),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Divider(
            height: AppSpacing.xxl,
            color: theme.colorScheme.outlineVariant,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.subtotal,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: AppDurations.fast,
                child: Text(
                  formatCurrency(cart.subtotal, currencyCode: currencyCode),
                  key: ValueKey(cart.subtotalCents),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
