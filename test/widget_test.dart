import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/app/app.dart';
import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/app_settings.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  late CatalogData sampleCatalog;

  setUpAll(() {
    final rawJson = File(AppAssets.catalogData).readAsStringSync();
    sampleCatalog = CatalogData.fromJson(
      jsonDecode(rawJson) as Map<String, Object?>,
    );
  });

  testWidgets('shows the home route', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appSettingsProvider.overrideWithValue(const AppSettings())],
        child: const BusinessCatalogApp(),
      ),
    );

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.catalogTitle), findsOneWidget);
    expect(find.text(AppStrings.cartTitle), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('uses push navigation for product details and supports back', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWithValue(const AppSettings()),
          catalogDataProvider.overrideWithValue(AsyncData(sampleCatalog)),
        ],
        child: const BusinessCatalogApp(),
      ),
    );

    await tester.tap(find.text(AppStrings.catalogTitle));
    await tester.pumpAndSettle();

    expect(find.text('Catalogly Kitchen'), findsOneWidget);
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);

    await tester.tap(find.text('Crispy Halloumi Bites'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.productDetailsTitle), findsWidgets);
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.text(AppStrings.catalogTitle), findsOneWidget);
    expect(find.text(AppStrings.productDetailsTitle), findsNothing);
  });

  testWidgets('catalog route can be opened as a top-level destination', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWithValue(const AppSettings()),
          catalogDataProvider.overrideWithValue(AsyncData(sampleCatalog)),
        ],
        child: const BusinessCatalogApp(),
      ),
    );

    await tester.tap(find.text(AppStrings.catalogTitle));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.catalogTitle), findsOneWidget);
    expect(
      tester
          .widgetList<AppBar>(find.byType(AppBar))
          .first
          .automaticallyImplyLeading,
      isTrue,
    );
    expect(AppRoutePaths.catalog, '/catalog');
  });
}
