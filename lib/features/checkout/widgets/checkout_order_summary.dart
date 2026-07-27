import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.orderSummary, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final item in cart.items) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity} x ${item.product.name}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatCurrency(item.lineTotal, currencyCode: currencyCode),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.subtotal,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  formatCurrency(cart.subtotal, currencyCode: currencyCode),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
