import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      _HomeDestination(
        title: AppStrings.catalogTitle,
        icon: Icons.storefront_outlined,
        location: AppRoutePaths.catalog,
      ),
      _HomeDestination(
        title: AppStrings.cartTitle,
        icon: Icons.shopping_bag_outlined,
        location: AppRoutePaths.cart,
      ),
      _HomeDestination(
        title: AppStrings.businessInfoTitle,
        icon: Icons.info_outline,
        location: AppRoutePaths.businessInfo,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appTitle)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: destinations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final destination = destinations[index];

            return Card(
              child: ListTile(
                leading: Icon(destination.icon),
                title: Text(destination.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(destination.location),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeDestination {
  const _HomeDestination({
    required this.title,
    required this.icon,
    required this.location,
  });

  final String title;
  final IconData icon;
  final String location;
}
