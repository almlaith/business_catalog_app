import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/features/cart/application/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItemQuantity = ref.watch(
      cartControllerProvider.select((cart) => cart.totalItemQuantity),
    );
    final l10n = context.l10n;

    return Scaffold(
      body: TweenAnimationBuilder<double>(
        key: ValueKey(navigationShell.currentIndex),
        tween: Tween(begin: 0, end: 1),
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 6 * (1 - value)),
              child: child,
            ),
          );
        },
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goToBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront),
            label: l10n.catalogTitle,
          ),
          NavigationDestination(
            icon: _CartIcon(
              icon: Icons.shopping_bag_outlined,
              totalItemQuantity: totalItemQuantity,
            ),
            selectedIcon: _CartIcon(
              icon: Icons.shopping_bag,
              totalItemQuantity: totalItemQuantity,
            ),
            label: l10n.cartTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            label: l10n.businessInfoTitle,
          ),
        ],
      ),
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.icon, required this.totalItemQuantity});

  final IconData icon;
  final int totalItemQuantity;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon);

    if (totalItemQuantity <= 0) {
      return iconWidget;
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey(totalItemQuantity),
      tween: Tween(begin: 0.86, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Badge(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onSecondary,
        label: Text('$totalItemQuantity'),
        child: iconWidget,
      ),
    );
  }
}
