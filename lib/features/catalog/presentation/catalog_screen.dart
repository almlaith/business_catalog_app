import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/catalog/utils/catalog_view_data.dart';
import 'package:business_catalog_app/features/catalog/widgets/category_selector.dart';
import 'package:business_catalog_app/features/catalog/widgets/product_card.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({this.initialCategoryId, super.key});

  final String? initialCategoryId;

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  @override
  void didUpdateWidget(covariant CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialCategoryId != oldWidget.initialCategoryId) {
      _selectedCategoryId = widget.initialCategoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.catalogTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: catalogState.when(
          loading: () => const AppSkeletonCatalog(),
          error: (error, stackTrace) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(catalogDataProvider),
          ),
          data: (catalog) => _CatalogContent(
            catalog: catalog,
            selectedCategoryId: _validSelectedCategoryId(catalog),
            onCategorySelected: (categoryId) {
              setState(() => _selectedCategoryId = categoryId);
            },
          ),
        ),
      ),
    );
  }

  String? _validSelectedCategoryId(CatalogData catalog) {
    final selectedCategoryId = _selectedCategoryId;

    if (selectedCategoryId == null) {
      return null;
    }

    final category = catalog.categoryById(selectedCategoryId);
    if (category == null || !category.isActive) {
      return null;
    }

    return selectedCategoryId;
  }
}

class _CatalogContent extends StatelessWidget {
  const _CatalogContent({
    required this.catalog,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final CatalogData catalog;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = catalog.activeCategoriesSorted;
    final products = catalog.availableProductsForCategory(selectedCategoryId);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        CategorySelector(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          onSelected: onCategorySelected,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: AnimatedSwitcher(
            duration: AppDurations.medium,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: products.isEmpty
                ? AppEmptyState(
                    key: ValueKey('empty-$selectedCategoryId'),
                    message: l10n.noProducts,
                  )
                : LayoutBuilder(
                    key: ValueKey(
                      products.map((product) => product.id).join(','),
                    ),
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth < 360 ? 1 : 2;

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: columns == 1 ? 1.82 : 0.66,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return ProductCard(
                            product: product,
                            currencyCode: catalog.business.currencyCode,
                            compact: columns == 1,
                            onTap: () => context.push(
                              AppRoutePaths.productDetailsPath(product.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
