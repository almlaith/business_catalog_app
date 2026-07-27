import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/placeholder_screen.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessInfoScreen extends ConsumerWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return catalogState.when(
      loading: () => const _BusinessInfoScaffold(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => _BusinessInfoScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
      data: (catalog) => PlaceholderScreen(
        title: AppStrings.businessInfoTitle,
        subtitle: catalog.business.businessName,
        automaticallyImplyLeading: false,
      ),
    );
  }
}

class _BusinessInfoScaffold extends StatelessWidget {
  const _BusinessInfoScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.businessInfoTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: child),
    );
  }
}
