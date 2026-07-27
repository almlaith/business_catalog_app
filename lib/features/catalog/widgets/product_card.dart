import 'package:business_catalog_app/core/utils/currency_formatter.dart';
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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: compact ? 1.35 : 1.25,
              child: LocalAssetImage(
                assetPath: product.imageAsset,
                width: double.infinity,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
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
              ),
            ),
          ],
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
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          formatCurrency(price, currencyCode: currencyCode),
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (oldPrice != null && oldPrice > price)
          Text(
            formatCurrency(oldPrice, currencyCode: currencyCode),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
