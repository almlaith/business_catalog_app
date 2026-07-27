import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
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
        child: cart.isEmpty
            ? const _EmptyCart()
            : _CartContent(cart: cart, business: catalog.business),
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
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.clearCartQuestion),
        content: Text(context.l10n.clearCartMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.clear),
          ),
        ],
      ),
    );

    if (shouldClear ?? false) {
      ref.read(cartControllerProvider.notifier).clear();
    }
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppEmptyState(message: l10n.cartEmpty),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutePaths.catalog),
              icon: const Icon(Icons.storefront_outlined),
              label: Text(l10n.browseCatalog),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: null, child: Text(l10n.continueAction)),
          ],
        ),
      ),
    );
  }
}

class _CartContent extends ConsumerWidget {
  const _CartContent({required this.cart, required this.business});

  final CartState cart;
  final BusinessConfig business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(cartControllerProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: cart.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
              const SizedBox(height: 8),
              Text(
                l10n.checkoutNotImplemented,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
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
