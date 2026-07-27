import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/app/app.dart';
import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/app_settings.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
    await tester.scrollProductDetailsUntil(find.text('Crispy Halloumi Bites'));
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.text(AppStrings.catalogTitle), findsWidgets);
    expect(find.text(AppStrings.productDetailsTitle), findsNothing);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('product details shows loaded product content', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    expect(find.text(AppStrings.productDetailsTitle), findsWidgets);
    await tester.scrollProductDetailsUntil(find.text('Crispy Halloumi Bites'));
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);
    await tester.scrollProductDetailsUntil(
      find.text('Golden halloumi cubes served with lemon herb dip.'),
    );
    expect(
      find.text('Golden halloumi cubes served with lemon herb dip.'),
      findsOneWidget,
    );
    await tester.scrollProductDetailsUntil(find.text(AppStrings.available));
    expect(find.text(AppStrings.available), findsOneWidget);
    await tester.scrollProductDetailsUntil(find.text('vegetarian'));
    expect(find.text('vegetarian'), findsOneWidget);
    await tester.scrollProductDetailsUntil(find.text(r'$7.50'));
    expect(find.text(r'$7.50'), findsOneWidget);
  });

  testWidgets('product details quantity controls never go below one', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    await tester.scrollProductDetailsUntil(find.text('1'));
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('unavailable product disables add to cart', (
    WidgetTester tester,
  ) async {
    final firstProduct = sampleCatalog.products.first;
    final unavailableCatalog = sampleCatalog.copyWith(
      products: [
        firstProduct.copyWith(isAvailable: false),
        ...sampleCatalog.products.skip(1),
      ],
    );

    await tester.openProductByRoute(unavailableCatalog, firstProduct.id);

    await tester.scrollProductDetailsUntil(find.text(AppStrings.unavailable));
    expect(find.text(AppStrings.unavailable), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.addToCart),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('adding a product updates cart and badge', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    expect(find.byType(Badge), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, AppStrings.addToCart));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.addedToCart), findsOneWidget);
    expect(find.byType(Badge), findsWidgets);

    await tester.tap(find.text(AppStrings.viewCart));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.cartTitle), findsWidgets);
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);
    expect(find.text(r'$7.50'), findsWidgets);
  });

  testWidgets('cart item quantity changes update totals', (
    WidgetTester tester,
  ) async {
    await tester.addFirstProductAndOpenCart(sampleCatalog);

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsWidgets);
    expect(find.text(r'$15.00'), findsWidgets);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);
    expect(find.text(r'$7.50'), findsWidgets);
  });

  testWidgets('cart shows empty state', (WidgetTester tester) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.cartEmpty), findsOneWidget);
    expect(find.text(AppStrings.browseCatalog), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byType(Badge), findsNothing);
  });

  testWidgets('clear cart confirmation clears items', (
    WidgetTester tester,
  ) async {
    await tester.addFirstProductAndOpenCart(sampleCatalog);

    await tester.tap(find.byTooltip(AppStrings.clearCart));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.clearCartQuestion), findsOneWidget);

    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
    expect(find.text('Crispy Halloumi Bites'), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.clearCart));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.clear));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.cartEmpty), findsOneWidget);
    expect(find.byType(Badge), findsNothing);
  });

  testWidgets('continue button is disabled when cart is empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.continueAction),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('navigates from cart to checkout', (WidgetTester tester) async {
    await tester.addFirstProductAndOpenCart(sampleCatalog);

    await tester.tap(
      find.widgetWithText(FilledButton, AppStrings.continueAction),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.checkoutTitle), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('checkout validates required fields', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(sampleCatalog);

    await tester.tapSendOrder();

    expect(find.text(AppStrings.requiredField), findsAtLeastNWidgets(2));
  });

  testWidgets('delivery address is conditional and validated', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(sampleCatalog);

    expect(
      find.byKey(const ValueKey('checkout-delivery-address-field')),
      findsNothing,
    );

    await tester.tap(find.text(AppStrings.delivery));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('checkout-delivery-address-field')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('checkout-name-field')),
      'John Smith',
    );
    await tester.enterText(
      find.byKey(const ValueKey('checkout-phone-field')),
      '+1 555 123 4567',
    );
    await tester.tapSendOrder();

    expect(find.text(AppStrings.requiredField), findsOneWidget);
  });

  testWidgets('pickup checkout flow opens WhatsApp and asks to clear cart', (
    WidgetTester tester,
  ) async {
    final launcher = _FakeExternalLinkLauncher(canLaunchResult: true);
    await tester.openCheckoutWithProduct(
      sampleCatalog,
      externalLinkLauncher: launcher,
    );

    await tester.fillPickupCheckoutFields();
    await tester.tapSendOrder();

    expect(launcher.launchedUris, hasLength(1));
    expect(find.text(AppStrings.clearCartAfterOrderQuestion), findsOneWidget);

    await tester.tap(find.text(AppStrings.keepCart));
    await tester.pumpAndSettle();
    expect(find.byType(Badge), findsWidgets);
  });

  testWidgets('checkout shows launch failure feedback', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(
      sampleCatalog,
      externalLinkLauncher: _FakeExternalLinkLauncher(canLaunchResult: false),
    );

    await tester.fillPickupCheckoutFields();
    await tester.tapSendOrder();

    expect(find.text(AppStrings.whatsappUnavailable), findsOneWidget);
    expect(find.text(AppStrings.clearCartAfterOrderQuestion), findsNothing);
  });

  testWidgets('successful checkout clears cart only when confirmed', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(
      sampleCatalog,
      externalLinkLauncher: _FakeExternalLinkLauncher(canLaunchResult: true),
    );

    await tester.fillPickupCheckoutFields();
    await tester.tapSendOrder();
    await tester.tap(find.text(AppStrings.clear));
    await tester.pumpAndSettle();

    expect(find.byType(Badge), findsNothing);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.sendOrderViaWhatsapp),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('checkout supports system back navigation', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(sampleCatalog);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.text(AppStrings.cartTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('business information hides empty optional rows', (
    WidgetTester tester,
  ) async {
    final catalog = sampleCatalog.copyWith(
      business: sampleCatalog.business.copyWith(facebookUrl: ''),
    );
    await tester.pumpCatalogApp(catalogState: AsyncData(catalog));

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.phone), findsOneWidget);
    expect(find.text(AppStrings.email), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(AppStrings.instagram),
      160,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('business-info-scroll-view')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text(AppStrings.instagram), findsOneWidget);
    expect(find.text(AppStrings.facebook), findsNothing);
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
  Future<void> pumpCatalogApp({
    required AsyncValue<CatalogData> catalogState,
    ExternalLinkLauncher? externalLinkLauncher,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWithValue(const AppSettings()),
          catalogDataProvider.overrideWithValue(catalogState),
          if (externalLinkLauncher != null)
            externalLinkLauncherProvider.overrideWithValue(
              externalLinkLauncher,
            ),
        ],
        child: const BusinessCatalogApp(),
      ),
    );
  }

  Future<void> openFirstProduct(
    CatalogData catalog, {
    ExternalLinkLauncher? externalLinkLauncher,
  }) async {
    await pumpCatalogApp(
      catalogState: AsyncData(catalog),
      externalLinkLauncher: externalLinkLauncher,
    );
    await tap(find.byIcon(Icons.storefront_outlined));
    await pumpAndSettle();
    await tap(find.text('Crispy Halloumi Bites'));
    await pumpAndSettle();
  }

  Future<void> openProductByRoute(CatalogData catalog, String productId) async {
    await pumpCatalogApp(catalogState: AsyncData(catalog));
    final context = element(find.byType(NavigationBar));
    GoRouter.of(context).push('/catalog/$productId');
    await pumpAndSettle();
  }

  Future<void> addFirstProductAndOpenCart(
    CatalogData catalog, {
    ExternalLinkLauncher? externalLinkLauncher,
  }) async {
    await openFirstProduct(catalog, externalLinkLauncher: externalLinkLauncher);
    await tap(find.widgetWithText(FilledButton, AppStrings.addToCart));
    await pumpAndSettle();
    await tap(find.text(AppStrings.viewCart));
    await pumpAndSettle();
  }

  Future<void> openCheckoutWithProduct(
    CatalogData catalog, {
    ExternalLinkLauncher? externalLinkLauncher,
  }) async {
    await addFirstProductAndOpenCart(
      catalog,
      externalLinkLauncher: externalLinkLauncher,
    );
    await tap(find.widgetWithText(FilledButton, AppStrings.continueAction));
    await pumpAndSettle();
  }

  Future<void> fillPickupCheckoutFields() async {
    await enterText(
      find.byKey(const ValueKey('checkout-name-field')),
      'John Smith',
    );
    await enterText(
      find.byKey(const ValueKey('checkout-phone-field')),
      '+1 555 123 4567',
    );
    await pumpAndSettle();
  }

  Future<void> tapSendOrder() async {
    await scrollUntilVisible(
      find.text(AppStrings.sendOrderViaWhatsapp),
      180,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('checkout-scroll-view')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tap(find.text(AppStrings.sendOrderViaWhatsapp));
    await pumpAndSettle();
  }

  Future<void> scrollProductDetailsUntil(Finder finder) async {
    await scrollUntilVisible(
      finder,
      120,
      scrollable: find.descendant(
        of: find.byType(Scaffold).last,
        matching: find.byType(Scrollable),
      ),
    );
  }
}

class _FakeExternalLinkLauncher implements ExternalLinkLauncher {
  _FakeExternalLinkLauncher({required this.canLaunchResult});

  final bool canLaunchResult;
  final launchedUris = <Uri>[];

  @override
  Future<bool> canLaunch(Uri uri) async => canLaunchResult;

  @override
  Future<bool> launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    launchedUris.add(uri);
    return canLaunchResult;
  }
}
