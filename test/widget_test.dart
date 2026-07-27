import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/app/app.dart';
import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/app_settings.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CatalogData sampleCatalog;

  setUpAll(() {
    final rawJson = File(AppAssets.catalogData).readAsStringSync();
    sampleCatalog = CatalogData.fromJson(
      jsonDecode(rawJson) as Map<String, Object?>,
    );
  });

  testWidgets('home shows a loading state', (WidgetTester tester) async {
    await tester.pumpCatalogApp(
      catalogState: const AsyncLoading<CatalogData>(),
    );

    expect(find.text(AppStrings.homeTitle), findsWidgets);
    expect(find.text(AppStrings.loadingCatalog), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('home shows business branding and catalog sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    expect(find.text('Catalogly Kitchen'), findsOneWidget);
    expect(find.text(AppStrings.categoriesSection), findsOneWidget);
    expect(find.text(AppStrings.featuredSection), findsOneWidget);
    expect(find.text('Starters'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Crispy Halloumi Bites'),
      160,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('bottom navigation opens top-level destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.catalogTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.cartTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.businessInfoTitle), findsWidgets);
    expect(find.text('Catalogly Kitchen'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('home category tap opens catalog filtered by that category', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(find.text('Mains'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.catalogTitle), findsWidgets);
    expect(find.text('Chargrilled Chicken Plate'), findsOneWidget);
    expect(find.text('Crispy Halloumi Bites'), findsNothing);
  });

  testWidgets('catalog filters products by selected category', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);

    await tester.tap(find.text('Desserts'));
    await tester.pumpAndSettle();

    expect(find.text('Classic Cheesecake'), findsOneWidget);
    expect(find.text('Crispy Halloumi Bites'), findsNothing);
  });

  testWidgets('product details opens with push navigation and supports back', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crispy Halloumi Bites'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.productDetailsTitle), findsWidgets);
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.text(AppStrings.catalogTitle), findsWidgets);
    expect(find.text(AppStrings.productDetailsTitle), findsNothing);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('local asset image shows fallback for a missing image', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LocalAssetImage(
            assetPath: 'assets/images/does_not_exist.png',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('missing-asset-image-placeholder')),
      findsOneWidget,
    );
  });
}

extension on WidgetTester {
  Future<void> pumpCatalogApp({required AsyncValue<CatalogData> catalogState}) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWithValue(const AppSettings()),
          catalogDataProvider.overrideWithValue(catalogState),
        ],
        child: const BusinessCatalogApp(),
      ),
    );
  }
}
