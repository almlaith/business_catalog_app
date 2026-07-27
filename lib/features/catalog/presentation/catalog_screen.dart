import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/core/widgets/aurora_refresh.dart';
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
      body: AuroraBackground(
        child: SafeArea(
          child: catalogState.when(
            skipLoadingOnRefresh: true,
            skipError: true,
            loading: () => const AppSkeletonCatalog(),
            error: (error, stackTrace) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(catalogDataProvider),
            ),
            data: (catalog) => AuroraRefreshWrapper(
              onRefresh: () => ref.refresh(catalogDataProvider.future),
              child: _CatalogContent(
                catalog: catalog,
                selectedCategoryId: _validSelectedCategoryId(catalog),
                onCategorySelected: (categoryId) {
                  setState(() => _selectedCategoryId = categoryId);
                },
              ),
            ),
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
    final selectedId = selectedCategoryId;
    final selectedCategory = selectedId == null
        ? null
        : catalog.categoryById(selectedId);

    return AnimatedSwitcher(
      duration: AppDurations.medium,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: LayoutBuilder(
        key: ValueKey('catalog-${selectedCategoryId ?? 'all'}'),
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 360 ? 1 : 2;

          return CustomScrollView(
            key: const ValueKey('catalog-scroll-view'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                sliver: SliverToBoxAdapter(
                  child: AuroraCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AuroraSectionHeader(
                      title: selectedCategory?.name ?? l10n.catalogTitle,
                      subtitle:
                          selectedCategory?.description ??
                          catalog.business.shortDescription,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: CategorySelector(
                  categories: categories,
                  selectedCategoryId: selectedCategoryId,
                  onSelected: onCategorySelected,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              if (products.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    key: ValueKey('empty-$selectedCategoryId'),
                    message: l10n.noProducts,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    118,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: columns == 1 ? 1.72 : 0.62,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,
                        currencyCode: catalog.business.currencyCode,
                        compact: columns == 1,
                        onTap: () => context.push(
                          AppRoutePaths.productDetailsPath(product.id),
                        ),
                      );
                    }, childCount: products.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
