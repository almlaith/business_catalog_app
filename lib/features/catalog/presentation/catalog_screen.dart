import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return catalogState.when(
      loading: () => const _CatalogScaffold(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => _CatalogScaffold(
        child: _CatalogError(
          error: error,
          onRetry: () => ref.invalidate(catalogDataProvider),
        ),
      ),
      data: (catalog) =>
          _CatalogScaffold(child: _CatalogPlaceholderContent(catalog: catalog)),
    );
  }
}

class _CatalogScaffold extends StatelessWidget {
  const _CatalogScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.catalogTitle)),
      body: SafeArea(child: child),
    );
  }
}

class _CatalogPlaceholderContent extends StatelessWidget {
  const _CatalogPlaceholderContent({required this.catalog});

  final CatalogData catalog;

  @override
  Widget build(BuildContext context) {
    final activeCategories = [...catalog.categories]
      ..removeWhere((category) => !category.isActive)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    final availableProducts = [...catalog.products]
      ..removeWhere((product) => !product.isAvailable)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          catalog.business.businessName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.placeholderLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Text('Categories', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final category in activeCategories)
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(category.name),
            subtitle: Text(category.description),
          ),
        const SizedBox(height: 16),
        Text('Products', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final product in availableProducts)
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(product.name),
              subtitle: Text(
                '${catalog.business.currencyCode} ${product.price}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  context.push(AppRoutePaths.productDetailsPath(product.id)),
            ),
          ),
      ],
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(height: 12),
            const Text(AppStrings.unableToLoadCatalog),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
