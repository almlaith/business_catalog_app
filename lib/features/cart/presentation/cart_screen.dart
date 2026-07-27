import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_confirmation_dialog.dart';
import 'package:business_catalog_app/features/cart/application/cart_controller.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:business_catalog_app/features/cart/widgets/cart_item_tile.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    final catalogState = ref.watch(catalogDataProvider);

    return catalogState.when(
      loading: () => const _CartScaffold(child: AppLoadingState()),
      error: (error, stackTrace) => _CartScaffold(
        child: AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(catalogDataProvider),
        ),
      ),
      data: (catalog) => _CartScaffold(
        cart: cart,
        child: AnimatedSwitcher(
          duration: AppDurations.medium,
          child: cart.isEmpty
              ? const _EmptyCart(key: ValueKey('empty-cart'))
              : _CartContent(
                  key: const ValueKey('filled-cart'),
                  cart: cart,
                  business: catalog.business,
                ),
        ),
      ),
    );
  }
}

class _CartScaffold extends ConsumerWidget {
  const _CartScaffold({required this.child, this.cart});

  final Widget child;
  final CartState? cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = this.cart;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        automaticallyImplyLeading: false,
        actions: [
          if (cart != null && cart.isNotEmpty)
            IconButton(
              tooltip: l10n.clearCart,
              onPressed: () => _confirmClearCart(context, ref),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }

  Future<void> _confirmClearCart(BuildContext context, WidgetRef ref) async {
    final shouldClear = await showAppConfirmationDialog(
      context: context,
      icon: Icons.delete_sweep_outlined,
      title: context.l10n.clearCartQuestion,
      message: context.l10n.clearCartMessage,
      cancelLabel: context.l10n.cancel,
      confirmLabel: context.l10n.clear,
      isDestructive: true,
    );

    if (shouldClear) {
      ref.read(cartControllerProvider.notifier).clear();
    }
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 42,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.cartEmpty,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutePaths.catalog),
              icon: const Icon(Icons.storefront_outlined),
              label: Text(l10n.browseCatalog),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: null, child: Text(l10n.continueAction)),
          ],
        ),
      ),
    );
  }
}

class _CartContent extends ConsumerWidget {
  const _CartContent({required this.cart, required this.business, super.key});

  final CartState cart;
  final BusinessConfig business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(cartControllerProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            itemCount: cart.items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = cart.items[index];

              return CartItemTile(
                item: item,
                currencyCode: business.currencyCode,
                onIncrement: () => controller.increaseQuantity(item.product.id),
                onDecrement: () => controller.decreaseQuantity(item.product.id),
                onRemove: () => controller.removeProduct(item.product.id),
              );
            },
          ),
        ),
        _CartSummary(cart: cart, currencyCode: business.currencyCode),
      ],
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.cart, required this.currencyCode});

  final CartState cart;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.subtotal,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatCurrency(cart.subtotal, currencyCode: currencyCode),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.checkoutNotImplemented,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () => context.push(AppRoutePaths.checkout),
                child: Text(l10n.continueAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
