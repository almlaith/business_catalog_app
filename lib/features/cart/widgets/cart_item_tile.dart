import 'package:business_catalog_app/core/utils/currency_formatter.dart';
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalAssetImage(
              assetPath: item.product.imageAsset,
              width: 76,
              height: 76,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 12),
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
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove item',
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  Text(
                    formatCurrency(
                      item.product.price,
                      currencyCode: currencyCode,
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      QuantityStepper(
                        quantity: item.quantity,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                      ),
                      Text(
                        formatCurrency(
                          item.lineTotal,
                          currencyCode: currencyCode,
                        ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
