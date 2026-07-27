import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
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
      loading: () => const _ProductDetailsScaffold(child: AppSkeletonDetails()),
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
      body: AuroraBackground(child: SafeArea(child: child)),
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
      body: AuroraBackground(
        bottomSafeGlow: true,
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 152),
            children: [
              SizedBox(
                height: AppHeights.imageHeader,
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
                            Colors.black.withValues(alpha: 0.04),
                            Colors.black.withValues(alpha: 0.50),
                          ],
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: AppSpacing.lg,
                      end: AppSpacing.lg,
                      bottom: AppSpacing.lg,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1.02,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          _AvailabilityChip(isAvailable: product.isAvailable),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: AuroraCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  useGradientBorder: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductDetailsPrice(
                        price: product.price,
                        oldPrice: product.oldPrice,
                        currencyCode: business.currencyCode,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.42,
                        ),
                      ),
                      if (product.tags.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            for (final tag in product.tags)
                              _TagPill(label: tag),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(AppRadii.xxl),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Padding(
            padding: AppSpacing.card,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
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
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AuroraGradientFilledButton(
                        onPressed: product.isAvailable ? _addToCart : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(
                          l10n.addToCart,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    ref
        .read(cartControllerProvider.notifier)
        .addProduct(widget.product, quantity: _quantity);

    showAppFeedback(
      context,
      type: AppFeedbackType.success,
      title: context.l10n.successTitle,
      message: context.l10n.addedToCart,
      action: SnackBarAction(
        label: context.l10n.viewCart,
        onPressed: () => context.go(AppRoutePaths.cart),
      ),
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  const _AvailabilityChip({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = isAvailable ? AuroraColors.success : AuroraColors.error;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.44),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: accent.withValues(alpha: 0.50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAvailable ? Icons.check_circle_rounded : Icons.block_rounded,
              size: 15,
              color: accent,
            ),
            const SizedBox(width: 6),
            Text(
              isAvailable ? l10n.available : l10n.unavailable,
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

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
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
            fontWeight: FontWeight.w900,
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
