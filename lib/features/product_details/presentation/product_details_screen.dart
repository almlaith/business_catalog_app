import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/cart/application/cart_controller.dart';
import 'package:business_catalog_app/features/cart/widgets/quantity_stepper.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/catalog/utils/catalog_view_data.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return catalogState.when(
      loading: () => const _ProductDetailsScaffold(child: AppLoadingState()),
      error: (error, stackTrace) =>
          _ProductDetailsScaffold(child: AppErrorState(error: error)),
      data: (catalog) {
        final product = catalog.productById(productId);

        if (product == null) {
          return _ProductDetailsScaffold(
            child: AppErrorState(
              title: context.l10n.productNotFound,
              error: productId,
            ),
          );
        }

        return _ProductDetailsContent(
          product: product,
          business: catalog.business,
        );
      },
    );
  }
}

class _ProductDetailsScaffold extends StatelessWidget {
  const _ProductDetailsScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.productDetailsTitle)),
      body: SafeArea(child: child),
    );
  }
}

class _ProductDetailsContent extends ConsumerStatefulWidget {
  const _ProductDetailsContent({required this.product, required this.business});

  final Product product;
  final BusinessConfig business;

  @override
  ConsumerState<_ProductDetailsContent> createState() =>
      _ProductDetailsContentState();
}

class _ProductDetailsContentState
    extends ConsumerState<_ProductDetailsContent> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final business = widget.business;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.productDetailsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            AspectRatio(
              aspectRatio: 1.35,
              child: LocalAssetImage(
                assetPath: product.imageAsset,
                width: double.infinity,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _AvailabilityChip(isAvailable: product.isAvailable),
              ],
            ),
            const SizedBox(height: 12),
            _ProductDetailsPrice(
              price: product.price,
              oldPrice: product.oldPrice,
              currencyCode: business.currencyCode,
            ),
            const SizedBox(height: 16),
            Text(product.description, style: theme.textTheme.bodyLarge),
            if (product.tags.isNotEmpty) ...[
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in product.tags)
                    Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            QuantityStepper(
              quantity: _quantity,
              canDecrement: _quantity > 1,
              onIncrement: () => setState(() => _quantity += 1),
              onDecrement: () {
                if (_quantity == 1) {
                  return;
                }

                setState(() => _quantity -= 1);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FilledButton.icon(
          onPressed: product.isAvailable ? _addToCart : null,
          icon: const Icon(Icons.add_shopping_cart),
          label: Text(l10n.addToCart),
        ),
      ),
    );
  }

  void _addToCart() {
    ref
        .read(cartControllerProvider.notifier)
        .addProduct(widget.product, quantity: _quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.addedToCart),
        action: SnackBarAction(
          label: context.l10n.viewCart,
          onPressed: () => context.go(AppRoutePaths.cart),
        ),
      ),
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  const _AvailabilityChip({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Chip(
      avatar: Icon(
        isAvailable ? Icons.check_circle_outline : Icons.do_not_disturb_on,
        size: 18,
      ),
      label: Text(isAvailable ? l10n.available : l10n.unavailable),
      backgroundColor: isAvailable
          ? colorScheme.secondaryContainer
          : colorScheme.errorContainer,
    );
  }
}

class _ProductDetailsPrice extends StatelessWidget {
  const _ProductDetailsPrice({
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
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          formatCurrency(price, currencyCode: currencyCode),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (oldPrice != null && oldPrice > price)
          Text(
            formatCurrency(oldPrice, currencyCode: currencyCode),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
