import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/placeholder_screen.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return catalogState.when(
      loading: () => const _ProductDetailsScaffold(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => _ProductDetailsScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
      data: (catalog) {
        final matches = catalog.products.where(
          (product) => product.id == productId,
        );
        final product = matches.isEmpty ? null : matches.first;

        return PlaceholderScreen(
          title: AppStrings.productDetailsTitle,
          subtitle: product?.name ?? AppStrings.productNotFound,
        );
      },
    );
  }
}

class _ProductDetailsScaffold extends StatelessWidget {
  const _ProductDetailsScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.productDetailsTitle)),
      body: SafeArea(child: child),
    );
  }
}
