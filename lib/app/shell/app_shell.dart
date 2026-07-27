import 'package:business_catalog_app/core/constants/app_strings.dart';
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

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goToBranch,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.homeTitle,
          ),
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: AppStrings.catalogTitle,
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
            label: AppStrings.cartTitle,
          ),
          const NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: AppStrings.businessInfoTitle,
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

    return Badge(label: Text('$totalItemQuantity'), child: iconWidget);
  }
}
