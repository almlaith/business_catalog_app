import 'package:business_catalog_app/core/constants/app_constants.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: AppStrings.catalogTitle,
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(
            AppRoutePaths.productDetailsPath(AppConstants.placeholderProductId),
          ),
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text(AppStrings.productDetailsTitle),
        ),
      ],
    );
  }
}
