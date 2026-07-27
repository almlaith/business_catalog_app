import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/catalog/utils/catalog_view_data.dart';
import 'package:business_catalog_app/features/catalog/widgets/category_card.dart';
import 'package:business_catalog_app/features/catalog/widgets/product_card.dart';
import 'package:business_catalog_app/features/home/widgets/home_header.dart';
import 'package:business_catalog_app/features/home/widgets/home_section_header.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: catalogState.when(
          loading: () => const AppLoadingState(),
          error: (error, stackTrace) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(catalogDataProvider),
          ),
          data: (catalog) => _HomeContent(catalog: catalog),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.catalog});

  final CatalogData catalog;

  @override
  Widget build(BuildContext context) {
    final categories = catalog.activeCategoriesSorted;
    final featuredProducts = catalog.featuredAvailableProductsSorted;
    final l10n = context.l10n;

    if (categories.isEmpty && featuredProducts.isEmpty) {
      return AppEmptyState(message: l10n.noProducts);
    }

    return ListView(
      padding: AppSpacing.page,
      children: [
        HomeHeader(
          business: catalog.business,
          onBrowse: () => context.go(AppRoutePaths.catalog),
        ),
        const SizedBox(height: AppSpacing.xxl),
        HomeSectionHeader(
          title: l10n.categoriesSection,
          action: TextButton(
            onPressed: () => context.go(AppRoutePaths.catalog),
            child: Text(l10n.viewCatalog),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (categories.isEmpty)
          SizedBox(
            height: 120,
            child: AppEmptyState(message: l10n.noCategories),
          )
        else
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final category = categories[index];

                return CategoryCard(
                  category: category,
                  onTap: () =>
                      context.go(AppRoutePaths.catalogForCategory(category.id)),
                );
              },
            ),
          ),
        const SizedBox(height: AppSpacing.xxl),
        HomeSectionHeader(
          title: l10n.featuredSection,
          action: TextButton(
            onPressed: () => context.go(AppRoutePaths.catalog),
            child: Text(l10n.viewCatalog),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (featuredProducts.isEmpty)
          SizedBox(
            height: 120,
            child: AppEmptyState(message: l10n.noFeaturedProducts),
          )
        else
          SizedBox(
            height: 318,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final product = featuredProducts[index];

                return SizedBox(
                  width: 212,
                  child: ProductCard(
                    product: product,
                    currencyCode: catalog.business.currencyCode,
                    onTap: () => context.push(
                      AppRoutePaths.productDetailsPath(product.id),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
