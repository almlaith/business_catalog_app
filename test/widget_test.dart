import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/app/app.dart';
import 'package:business_catalog_app/app/app_bootstrap.dart';
import 'package:business_catalog_app/app/theme/app_theme.dart';
import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/core/constants/app_locales.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/l10n/generated/app_localizations_en.dart';
import 'package:business_catalog_app/l10n/generated/app_localizations_ar.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/widgets/category_card.dart';
import 'package:business_catalog_app/features/catalog/widgets/product_card.dart';
import 'package:business_catalog_app/features/help_support/presentation/help_support_screen.dart';
import 'package:business_catalog_app/features/launch/presentation/animated_launch_screen.dart';
import 'package:business_catalog_app/models/app_settings.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/features/settings/presentation/settings_screen.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

final l10n = AppLocalizationsEn();
final arL10n = AppLocalizationsAr();

void main() {
  late CatalogData sampleCatalog;

  setUpAll(() {
    final rawJson = File(AppAssets.catalogData).readAsStringSync();
    sampleCatalog = CatalogData.fromJson(
      jsonDecode(rawJson) as Map<String, Object?>,
    );
  });

  testWidgets('portrait orientation initialization is configured', (
    WidgetTester tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await configurePortraitOrientation();

    expect(calls.single.method, 'SystemChrome.setPreferredOrientations');
    expect(calls.single.arguments, ['DeviceOrientation.portraitUp']);
  });

  testWidgets('animated launch screen completes before app interaction', (
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

    expect(
      find.byKey(const ValueKey('animated-launch-screen')),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('animated-launch-screen')), findsNothing);
    expect(find.text(l10n.homeTitle), findsWidgets);
  });

  testWidgets('home shows a loading state', (WidgetTester tester) async {
    await tester.pumpCatalogApp(
      catalogState: const AsyncLoading<CatalogData>(),
    );

    expect(find.text(l10n.homeTitle), findsWidgets);
    expect(find.text(l10n.loadingCatalog), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('home shows business branding and catalog sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    expect(find.text('Aura Atelier'), findsOneWidget);
    expect(find.text(l10n.categoriesSection), findsOneWidget);
    expect(find.text('Signature Scents'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.featuredSection),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.featuredSection), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Midnight Veil'),
      160,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Midnight Veil'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('bottom navigation opens top-level destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tapNavLabel(l10n.catalogTitle);
    await tester.pumpAndSettle();
    expect(find.text(l10n.catalogTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);

    await tester.tapNavLabel(l10n.cartTitle);
    await tester.pumpAndSettle();
    expect(find.text(l10n.cartTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);

    await tester.tapNavLabel(l10n.businessInfoNavLabel);
    await tester.pumpAndSettle();
    expect(find.text(l10n.businessInfoTitle), findsWidgets);
    expect(find.text('Aura Atelier'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('custom bottom navigation replaces default NavigationBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text(l10n.homeTitle), findsWidgets);
    expect(find.text(l10n.catalogTitle), findsWidgets);
    expect(find.text(l10n.cartTitle), findsWidgets);
    expect(find.text(l10n.businessInfoNavLabel), findsWidgets);
  });

  testWidgets('bottom navigation labels stay single-line at 320dp', (
    WidgetTester tester,
  ) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;

    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));
    await tester.pumpAndSettle();

    for (final label in [
      l10n.homeTitle,
      l10n.catalogTitle,
      l10n.cartTitle,
      l10n.businessInfoNavLabel,
    ]) {
      final text = tester.widget<Text>(find.text(label).last);
      expect(text.maxLines, 1);
      expect(tester.getSize(find.text(label).last).height, lessThan(18));
    }
  });

  testWidgets('arabic bottom navigation labels stay single-line at 320dp', (
    WidgetTester tester,
  ) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;

    await tester.pumpCatalogApp(
      catalogState: AsyncData(sampleCatalog),
      appSettings: const AppSettings(localeCode: 'ar'),
    );
    await tester.pumpAndSettle();

    for (final label in [
      arL10n.homeTitle,
      arL10n.catalogTitle,
      arL10n.cartTitle,
      arL10n.businessInfoNavLabel,
    ]) {
      final text = tester.widget<Text>(find.text(label).last);
      expect(text.maxLines, 1);
      expect(tester.getSize(find.text(label).last).height, lessThan(18));
    }
  });

  testWidgets('fresh install defaults to dark theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    final theme = Theme.of(tester.element(find.byType(Scaffold).first));

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AuroraColors.darkBackground);
  });

  testWidgets('stored light preference remains light', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(
      catalogState: AsyncData(sampleCatalog),
      appSettings: const AppSettings(themeMode: 'light'),
    );

    final theme = Theme.of(tester.element(find.byType(Scaffold).first));

    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, isNot(Colors.white));
    expect(theme.scaffoldBackgroundColor, AuroraColors.lightBackground);
    expect(theme.colorScheme.surface, AuroraColors.lightCard);
  });

  testWidgets('stored system preference remains system', (
    WidgetTester tester,
  ) async {
    final service = _FakeSettingsStore(const AppSettings(themeMode: 'system'));
    await tester.pumpCatalogAppWithSettingsController(
      catalogState: AsyncData(sampleCatalog),
      localSettingsService: service,
    );

    expect(service.readSettings().themeMode, 'system');
  });

  testWidgets('dark theme uses layered ink surfaces', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(
      catalogState: AsyncData(sampleCatalog),
      appSettings: const AppSettings(themeMode: 'dark'),
    );

    final theme = Theme.of(tester.element(find.byType(Scaffold).first));

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AuroraColors.darkBackground);
    expect(theme.colorScheme.surface, AuroraColors.darkCard);
    expect(theme.colorScheme.surfaceContainerHighest, AuroraColors.darkStrong);
    expect(theme.scaffoldBackgroundColor, isNot(Colors.black));
  });

  testWidgets('home category tap opens catalog filtered by that category', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tap(
      find
          .ancestor(
            of: find.text('Oud Collection'),
            matching: find.byType(CategoryCard),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.catalogTitle), findsWidgets);
    expect(find.text('Imperial Oud'), findsOneWidget);
    expect(find.text('Midnight Veil'), findsNothing);
  });

  testWidgets('catalog filters products by selected category', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tapNavLabel(l10n.catalogTitle);
    await tester.pumpAndSettle();

    expect(find.text('Midnight Veil'), findsOneWidget);

    await tester.tap(find.text('Body Care'));
    await tester.pumpAndSettle();

    expect(find.text('Silk Body Lotion'), findsOneWidget);
    expect(find.text('Midnight Veil'), findsNothing);
  });

  testWidgets('product details opens with push navigation and supports back', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tapNavLabel(l10n.catalogTitle);
    await tester.pumpAndSettle();
    await tester.tapProductCard('Midnight Veil');
    await tester.pumpAndSettle();

    expect(find.text(l10n.productDetailsTitle), findsWidgets);
    await tester.scrollProductDetailsUntil(find.text('Midnight Veil'));
    expect(find.text('Midnight Veil'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.text(l10n.catalogTitle), findsWidgets);
    expect(find.text(l10n.productDetailsTitle), findsNothing);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('product details shows loaded product content', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    expect(find.text(l10n.productDetailsTitle), findsWidgets);
    await tester.scrollProductDetailsUntil(find.text('Midnight Veil'));
    expect(find.text('Midnight Veil'), findsOneWidget);
    await tester.scrollProductDetailsUntil(
      find.text('Dark violet woods softened by iris and clean musk.'),
    );
    expect(
      find.text('Dark violet woods softened by iris and clean musk.'),
      findsOneWidget,
    );
    await tester.scrollProductDetailsUntil(find.text(l10n.available));
    expect(find.text(l10n.available), findsOneWidget);
    await tester.scrollProductDetailsUntil(find.text('woody'));
    expect(find.text('woody'), findsOneWidget);
    await tester.scrollProductDetailsUntil(find.text(r'$96.00'));
    expect(find.text(r'$96.00'), findsOneWidget);
  });

  testWidgets('product details quantity controls never go below one', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    await tester.scrollProductDetailsUntil(find.text('1'));
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.decreaseQuantity));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.increaseQuantity));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.decreaseQuantity));
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

    await tester.scrollProductDetailsUntil(find.text(l10n.unavailable));
    expect(find.text(l10n.unavailable), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, l10n.addToCart),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('adding a product updates cart and badge', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    expect(find.byType(Badge), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, l10n.addToCart));
    await tester.pumpAndSettle();

    expect(find.text(l10n.addedToCart), findsOneWidget);
    expect(find.byType(Badge), findsWidgets);

    await tester.tap(find.text(l10n.viewCart));
    await tester.pumpAndSettle();

    expect(find.text(l10n.cartTitle), findsWidgets);
    expect(find.text('Midnight Veil'), findsOneWidget);
    expect(find.text(r'$96.00'), findsWidgets);
  });

  testWidgets('cart item quantity changes update totals', (
    WidgetTester tester,
  ) async {
    await tester.addFirstProductAndOpenCart(sampleCatalog);

    await tester.tap(find.byTooltip(l10n.increaseQuantity));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsWidgets);
    expect(find.text(r'$192.00'), findsWidgets);

    await tester.tap(find.byTooltip(l10n.decreaseQuantity));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);
    expect(find.text(r'$96.00'), findsWidgets);
  });

  testWidgets('cart shows empty state', (WidgetTester tester) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tapNavLabel(l10n.cartTitle);
    await tester.pumpAndSettle();

    expect(find.text(l10n.cartEmpty), findsOneWidget);
    expect(find.text(l10n.browseCatalog), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byType(Badge), findsNothing);
  });

  testWidgets('clear cart confirmation clears items', (
    WidgetTester tester,
  ) async {
    await tester.addFirstProductAndOpenCart(sampleCatalog);

    await tester.tap(find.byTooltip(l10n.clearCart));
    await tester.pumpAndSettle();

    expect(find.text(l10n.clearCartQuestion), findsOneWidget);

    await tester.tap(find.text(l10n.cancel));
    await tester.pumpAndSettle();
    expect(find.text('Midnight Veil'), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.clearCart));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.clear));
    await tester.pumpAndSettle();

    expect(find.text(l10n.cartEmpty), findsOneWidget);
    expect(find.byType(Badge), findsNothing);
  });

  testWidgets('continue button is disabled when cart is empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tapNavLabel(l10n.cartTitle);
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, l10n.continueAction),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('navigates from cart to checkout', (WidgetTester tester) async {
    await tester.addFirstProductAndOpenCart(sampleCatalog);

    await tester.tap(find.widgetWithText(FilledButton, l10n.continueAction));
    await tester.pumpAndSettle();

    expect(find.text(l10n.checkoutTitle), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('checkout validates required fields', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(sampleCatalog);

    await tester.tapSendOrder();

    expect(find.text(l10n.requiredField), findsAtLeastNWidgets(2));
  });

  testWidgets('delivery address is conditional and validated', (
    WidgetTester tester,
  ) async {
    await tester.openCheckoutWithProduct(sampleCatalog);

    expect(
      find.byKey(const ValueKey('checkout-delivery-address-field')),
      findsNothing,
    );

    await tester.drag(
      find
          .descendant(
            of: find.byKey(const ValueKey('checkout-scroll-view')),
            matching: find.byType(Scrollable),
          )
          .first,
      const Offset(0, -170),
    );
    await tester.pumpAndSettle();
    await tester.tapInkForText(l10n.delivery);
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

    expect(find.text(l10n.requiredField), findsOneWidget);
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
    expect(find.text(l10n.clearCartAfterOrderQuestion), findsOneWidget);

    await tester.tap(find.text(l10n.keepCart));
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

    expect(find.text(l10n.whatsappUnavailable), findsOneWidget);
    expect(find.text(l10n.clearCartAfterOrderQuestion), findsNothing);
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
    await tester.tap(find.text(l10n.clear));
    await tester.pumpAndSettle();

    expect(find.byType(Badge), findsNothing);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, l10n.sendOrderViaWhatsapp),
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
    expect(find.text(l10n.cartTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('business information hides empty optional rows', (
    WidgetTester tester,
  ) async {
    final catalog = sampleCatalog.copyWith(
      business: sampleCatalog.business.copyWith(facebookUrl: ''),
    );
    await tester.pumpCatalogApp(catalogState: AsyncData(catalog));

    await tester.tapNavLabel(l10n.businessInfoNavLabel);
    await tester.pumpAndSettle();

    expect(find.text(l10n.phone), findsOneWidget);
    expect(find.text(l10n.email), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.instagram),
      160,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('business-info-scroll-view')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text(l10n.instagram), findsOneWidget);
    expect(find.text(l10n.facebook), findsNothing);
  });

  testWidgets('settings navigation opens from business information', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.tapNavLabel(l10n.businessInfoNavLabel);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.settingsTitle), findsWidgets);
    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('settings screen fits at 320dp', (WidgetTester tester) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;

    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));
    await tester.openSettings();

    expect(find.text(l10n.preferencesSummaryTitle), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-preview-dark')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings screen supports Arabic RTL layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(
      catalogState: AsyncData(sampleCatalog),
      appSettings: const AppSettings(localeCode: 'ar'),
    );

    await tester.openSettings();

    expect(find.text(arL10n.preferencesSummaryTitle), findsOneWidget);
    expect(
      Directionality.of(
        tester.element(find.text(arL10n.preferencesSummaryTitle)),
      ),
      TextDirection.rtl,
    );
    expect(find.byKey(const ValueKey('language-card-ar')), findsOneWidget);
  });

  testWidgets('help screen opens from settings and supports back', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));

    await tester.openSettings();
    await tester.tapInkForText(l10n.helpSupportTitle);

    expect(find.byType(HelpSupportScreen), findsOneWidget);
    expect(find.text(l10n.quickSupportActions), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.text(l10n.settingsTitle), findsWidgets);
  });

  testWidgets('help screen hides unavailable support actions', (
    WidgetTester tester,
  ) async {
    final catalog = sampleCatalog.copyWith(
      business: sampleCatalog.business.copyWith(
        phoneNumber: '',
        email: '',
        whatsappNumber: '',
        instagramUrl: '',
        facebookUrl: '',
      ),
    );
    await tester.pumpCatalogApp(catalogState: AsyncData(catalog));

    await tester.openHelpSupportDirectly();

    expect(find.byKey(const ValueKey('support-action-call')), findsNothing);
    expect(find.byKey(const ValueKey('support-action-email')), findsNothing);
    expect(find.byKey(const ValueKey('support-action-whatsapp')), findsNothing);
    expect(
      find.byKey(const ValueKey('support-action-business-info')),
      findsOneWidget,
    );
  });

  testWidgets('FAQ accordion expands one answer at a time', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));
    await tester.openHelpSupportDirectly();
    await tester.scrollHelpUntil(find.text(l10n.faqPlaceOrderQuestion));

    await tester.tapInkForText(l10n.faqPlaceOrderQuestion);
    expect(find.text(l10n.faqPlaceOrderAnswer), findsOneWidget);

    await tester.tapInkForText(l10n.faqWhatsappQuestion);
    expect(find.text(l10n.faqWhatsappAnswer), findsOneWidget);
    expect(find.text(l10n.faqPlaceOrderAnswer), findsNothing);
  });

  testWidgets('support-link failure shows top feedback', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(
      catalogState: AsyncData(sampleCatalog),
      externalLinkLauncher: _FakeExternalLinkLauncher(canLaunchResult: false),
    );

    await tester.openHelpSupportDirectly();
    await tester.tapInkForText(l10n.callBusiness);
    await tester.pump();

    expect(find.text(l10n.unableToOpenLink), findsOneWidget);
    expect(
      tester.getTopLeft(find.text(l10n.unableToOpenLink)).dy,
      lessThan(170),
    );

    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pumpAndSettle();
  });

  testWidgets('switching to Arabic applies RTL immediately', (
    WidgetTester tester,
  ) async {
    final service = _FakeSettingsStore();
    await tester.pumpCatalogAppWithSettingsController(
      catalogState: AsyncData(sampleCatalog),
      localSettingsService: service,
    );

    await tester.openSettings();
    await tester.tapInkForText(l10n.arabicLanguage);
    await tester.pumpAndSettle();

    expect(find.text(arL10n.settingsTitle), findsWidgets);
    expect(
      Directionality.of(tester.element(find.text(arL10n.settingsTitle).first)),
      TextDirection.rtl,
    );
    expect(service.readSettings().localeCode, 'ar');
  });

  testWidgets('switches between system, light, and dark themes', (
    WidgetTester tester,
  ) async {
    final service = _FakeSettingsStore();
    await tester.pumpCatalogAppWithSettingsController(
      catalogState: AsyncData(sampleCatalog),
      localSettingsService: service,
    );

    await tester.openSettings();
    expect(find.byIcon(Icons.light_mode_rounded), findsWidgets);
    expect(find.byIcon(Icons.dark_mode_rounded), findsWidgets);
    await tester.drag(find.byType(ListView).last, const Offset(0, -220));
    await tester.pumpAndSettle();
    await tester.tapInkForText(l10n.darkTheme);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(SettingsScreen))).brightness,
      Brightness.dark,
    );
    expect(service.readSettings().themeMode, 'dark');

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(l10n.lightTheme));
    await tester.tapInkForText(l10n.lightTheme);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(SettingsScreen))).brightness,
      Brightness.light,
    );
    expect(service.readSettings().themeMode, 'light');

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, 160));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(l10n.systemTheme));
    await tester.tapInkForText(l10n.systemTheme);
    await tester.pumpAndSettle();
    expect(service.readSettings().themeMode, 'system');
  });

  testWidgets('resetting appearance settings uses confirmation dialog', (
    WidgetTester tester,
  ) async {
    final service = _FakeSettingsStore(
      const AppSettings(localeCode: 'ar', themeMode: 'dark'),
    );
    await tester.pumpCatalogAppWithSettingsController(
      catalogState: AsyncData(sampleCatalog),
      localSettingsService: service,
    );

    await tester.openSettings();
    await tester.drag(find.byType(ListView).last, const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tapInkForText(arL10n.resetAppearance);
    await tester.pumpAndSettle();
    expect(find.text(arL10n.resetAppearanceQuestion), findsOneWidget);

    await tester.tap(find.text(arL10n.reset));
    await tester.pumpAndSettle();

    expect(service.readSettings().localeCode, isNull);
    expect(service.readSettings().themeMode, 'dark');
    expect(find.text(l10n.settingsTitle), findsWidgets);
  });

  testWidgets('modern feedback component renders title and message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Host')),
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => showAppFeedback(
                context,
                type: AppFeedbackType.success,
                title: 'Saved',
                message: 'Preference applied',
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Preference applied'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Saved')).dy, lessThan(140));

    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pumpAndSettle();
  });

  testWidgets('top feedback notification automatically dismisses', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Host')),
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => showAppFeedback(
                context,
                type: AppFeedbackType.success,
                title: 'Done',
                message: 'Dismiss soon',
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text('Done'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsNothing);
  });

  testWidgets('feedback View Cart action navigates to cart', (
    WidgetTester tester,
  ) async {
    await tester.openFirstProduct(sampleCatalog);

    await tester.tap(find.widgetWithText(FilledButton, l10n.addToCart));
    await tester.pump();
    await tester.tap(find.text(l10n.viewCart));
    await tester.pumpAndSettle();

    expect(find.text(l10n.cartTitle), findsWidgets);
    expect(find.text('Midnight Veil'), findsWidgets);
  });

  testWidgets('feedback component renders all variants', (
    WidgetTester tester,
  ) async {
    for (final type in AppFeedbackType.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () => showAppFeedback(
                  context,
                  type: type,
                  title: type.name,
                  message: 'variant',
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text(type.name), findsOneWidget);
      expect(find.text('variant'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 3100));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('pull-to-refresh triggers provider refresh', (
    WidgetTester tester,
  ) async {
    final repository = _FakeCatalogRepository(sampleCatalog);
    await tester.pumpCatalogAppWithRepository(repository: repository);
    await tester.pumpAndSettle();

    expect(repository.loadCount, 1);

    await tester.pullToRefresh(find.byKey(const ValueKey('home-scroll-view')));
    await tester.pumpAndSettle();

    expect(repository.loadCount, 2);
  });

  testWidgets('refresh keeps loaded content visible', (
    WidgetTester tester,
  ) async {
    final repository = _FakeCatalogRepository(sampleCatalog);
    await tester.pumpCatalogAppWithRepository(repository: repository);
    await tester.pumpAndSettle();

    final pendingRefresh = Completer<CatalogData>();
    repository.nextResult = pendingRefresh.future;

    await tester.pullToRefresh(find.byKey(const ValueKey('home-scroll-view')));
    await tester.pump();

    expect(repository.loadCount, 2);
    expect(find.text('Aura Atelier'), findsOneWidget);
    expect(find.byType(AppSkeletonHome), findsNothing);

    pendingRefresh.complete(sampleCatalog);
    await tester.pumpAndSettle();
  });

  testWidgets('initial loading shows screen-specific skeletons', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(
      catalogState: const AsyncLoading<CatalogData>(),
    );

    expect(find.byType(AppSkeletonHome), findsOneWidget);

    final context = tester.element(find.byType(Scaffold).first);
    GoRouter.of(context).go(AppRoutePaths.helpSupport);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(AppSkeletonHelpSupport), findsOneWidget);
  });

  testWidgets('refresh failure keeps content and shows top feedback', (
    WidgetTester tester,
  ) async {
    final repository = _FakeCatalogRepository(sampleCatalog);
    await tester.pumpCatalogAppWithRepository(repository: repository);
    await tester.pumpAndSettle();

    final failedRefresh = Completer<CatalogData>();
    repository.nextResult = failedRefresh.future;

    await tester.pullToRefresh(find.byKey(const ValueKey('home-scroll-view')));
    failedRefresh.completeError(StateError('bad json'));
    await tester.pump();

    expect(find.text('Aura Atelier'), findsOneWidget);
    expect(find.byType(AppSkeletonHome), findsNothing);
    expect(find.text(l10n.refreshFailedTitle), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pumpAndSettle();
  });

  testWidgets('pull-to-refresh works with short content', (
    WidgetTester tester,
  ) async {
    final shortCatalog = sampleCatalog.copyWith(
      categories: const [],
      products: const [],
    );
    final repository = _FakeCatalogRepository(shortCatalog);
    await tester.pumpCatalogAppWithRepository(repository: repository);
    await tester.pumpAndSettle();

    await tester.pullToRefresh(find.byKey(const ValueKey('home-scroll-view')));
    await tester.pumpAndSettle();

    expect(repository.loadCount, 2);
    expect(find.text(l10n.noProducts), findsOneWidget);
  });

  testWidgets('light and dark skeletons use themed surfaces', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocales.supportedLocales,
        localizationsDelegates: AppLocales.localizationsDelegates,
        theme: AppTheme.light(
          primaryColor: AuroraColors.primaryViolet,
          secondaryColor: AuroraColors.electricCyan,
        ),
        home: const Scaffold(body: AppSkeletonHome()),
      ),
    );
    final lightBox = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AppSkeletonHome),
            matching: find.byType(DecoratedBox),
          )
          .last,
    );
    expect(lightBox.decoration, isA<BoxDecoration>());

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocales.supportedLocales,
        localizationsDelegates: AppLocales.localizationsDelegates,
        theme: AppTheme.light(
          primaryColor: AuroraColors.primaryViolet,
          secondaryColor: AuroraColors.electricCyan,
        ),
        darkTheme: AppTheme.dark(
          primaryColor: AuroraColors.primaryViolet,
          secondaryColor: AuroraColors.electricCyan,
        ),
        themeMode: ThemeMode.dark,
        home: const Scaffold(body: AppSkeletonHome()),
      ),
    );
    await tester.pump();
    final darkTheme = Theme.of(
      tester.element(find.byType(AppSkeletonHome).last),
    );

    expect(
      darkTheme.colorScheme.surfaceContainerLowest,
      AuroraColors.darkBackground,
    );
  });

  testWidgets('arabic localization uses RTL layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpCatalogApp(
      catalogState: AsyncData(sampleCatalog),
      appSettings: const AppSettings(localeCode: 'ar'),
    );

    expect(find.text(arL10n.homeTitle), findsWidgets);
    expect(
      Directionality.of(tester.element(find.text(arL10n.homeTitle).first)),
      TextDirection.rtl,
    );
  });

  testWidgets('long business text fits on narrow screens', (
    WidgetTester tester,
  ) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;

    final longTextCatalog = sampleCatalog.copyWith(
      business: sampleCatalog.business.copyWith(
        businessName:
            'A Very Long Reusable Business Catalog Template Display Name',
        shortDescription:
            'A long configurable business description that should remain readable without breaking the home header layout.',
        address:
            '12345 Extremely Long Street Name, Suite 900, Very Long District, Large City',
      ),
    );

    await tester.pumpCatalogApp(catalogState: AsyncData(longTextCatalog));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(longTextCatalog.business.businessName), findsOneWidget);
  });

  testWidgets('primary screens fit tested mobile widths', (
    WidgetTester tester,
  ) async {
    const widths = [320.0, 360.0, 430.0, 600.0];
    addTearDown(() => tester.view.resetPhysicalSize());

    for (final width in widths) {
      tester.view.physicalSize = Size(width, 820);
      tester.view.devicePixelRatio = 1;

      await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Home width $width');

      await tester.tapNavLabel(l10n.catalogTitle);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Catalog width $width');

      await tester.tapProductCard('Midnight Veil');
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Product details width $width',
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tapNavLabel(l10n.cartTitle);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Cart width $width');

      await tester.tapNavLabel(l10n.businessInfoNavLabel);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Business info width $width',
      );
    }
  });

  testWidgets('layout tolerates larger text scaling', (
    WidgetTester tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    tester.view.physicalSize = const Size(360, 820);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.35;

    await tester.pumpCatalogApp(catalogState: AsyncData(sampleCatalog));
    await tester.pumpAndSettle();
    await tester.tapNavLabel(l10n.catalogTitle);
    await tester.pumpAndSettle();
    await tester.tapProductCard('Midnight Veil');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
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
    AppSettings appSettings = const AppSettings(),
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          launchAnimationEnabledProvider.overrideWithValue(false),
          appSettingsProvider.overrideWithValue(appSettings),
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

  Future<void> pumpCatalogAppWithSettingsController({
    required AsyncValue<CatalogData> catalogState,
    required AppSettingsStore localSettingsService,
    ExternalLinkLauncher? externalLinkLauncher,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          launchAnimationEnabledProvider.overrideWithValue(false),
          localSettingsServiceProvider.overrideWithValue(localSettingsService),
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

  Future<void> pumpCatalogAppWithRepository({
    required CatalogRepository repository,
    ExternalLinkLauncher? externalLinkLauncher,
    AppSettingsStore? localSettingsService,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          launchAnimationEnabledProvider.overrideWithValue(false),
          catalogRepositoryProvider.overrideWithValue(repository),
          if (localSettingsService != null)
            localSettingsServiceProvider.overrideWithValue(localSettingsService)
          else
            appSettingsProvider.overrideWithValue(const AppSettings()),
          if (externalLinkLauncher != null)
            externalLinkLauncherProvider.overrideWithValue(
              externalLinkLauncher,
            ),
        ],
        child: const BusinessCatalogApp(),
      ),
    );
  }

  Future<void> openSettings() async {
    await tapNavLabelAny([
      l10n.businessInfoNavLabel,
      arL10n.businessInfoNavLabel,
    ]);
    await pumpAndSettle();
    final settingsTooltip =
        find.byTooltip(l10n.settingsTooltip).evaluate().isNotEmpty
        ? find.byTooltip(l10n.settingsTooltip)
        : find.byTooltip(arL10n.settingsTooltip);
    await tap(settingsTooltip);
    await pumpAndSettle();
  }

  Future<void> openHelpSupportDirectly() async {
    final context = element(find.byType(Scaffold).first);
    GoRouter.of(context).go(AppRoutePaths.helpSupport);
    await pumpAndSettle();
  }

  Future<void> scrollHelpUntil(Finder finder) async {
    await scrollUntilVisible(
      finder,
      180,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('help-support-scroll-view')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
  }

  Future<void> pullToRefresh(Finder scrollable) async {
    final start = getTopLeft(scrollable) + const Offset(24, 48);
    await timedDragFrom(
      start,
      const Offset(0, 520),
      const Duration(milliseconds: 600),
    );
    await pump(const Duration(milliseconds: 800));
  }

  Future<void> openFirstProduct(
    CatalogData catalog, {
    ExternalLinkLauncher? externalLinkLauncher,
  }) async {
    await pumpCatalogApp(
      catalogState: AsyncData(catalog),
      externalLinkLauncher: externalLinkLauncher,
    );
    await tapNavLabel(l10n.catalogTitle);
    await pumpAndSettle();
    await tapProductCard('Midnight Veil');
    await pumpAndSettle();
  }

  Future<void> openProductByRoute(CatalogData catalog, String productId) async {
    await pumpCatalogApp(catalogState: AsyncData(catalog));
    final context = element(find.byType(Scaffold).first);
    GoRouter.of(context).push('/catalog/$productId');
    await pumpAndSettle();
  }

  Future<void> addFirstProductAndOpenCart(
    CatalogData catalog, {
    ExternalLinkLauncher? externalLinkLauncher,
  }) async {
    await openFirstProduct(catalog, externalLinkLauncher: externalLinkLauncher);
    await tap(find.widgetWithText(FilledButton, l10n.addToCart));
    await pumpAndSettle();
    await tap(find.text(l10n.viewCart));
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
    await tap(find.widgetWithText(FilledButton, l10n.continueAction));
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
    final scrollable = find
        .descendant(
          of: find.byKey(const ValueKey('checkout-scroll-view')),
          matching: find.byType(Scrollable),
        )
        .first;
    await scrollUntilVisible(
      find.text(l10n.sendOrderViaWhatsapp),
      180,
      scrollable: scrollable,
    );
    await drag(scrollable, const Offset(0, -160));
    await pumpAndSettle();
    await tap(find.widgetWithText(FilledButton, l10n.sendOrderViaWhatsapp));
    await pumpAndSettle();
  }

  Future<void> scrollProductDetailsUntil(Finder finder) async {
    await scrollUntilVisible(
      finder,
      120,
      scrollable: find.byType(Scrollable).last,
    );
  }

  Future<void> tapNavLabel(String label) async {
    await tap(find.text(label).last);
    await pumpAndSettle();
  }

  Future<void> tapNavLabelAny(List<String> labels) async {
    for (final label in labels) {
      final finder = find.text(label);
      if (finder.evaluate().isNotEmpty) {
        await tap(finder.last);
        await pumpAndSettle();
        return;
      }
    }
    throw StateError('No navigation label found for $labels');
  }

  Future<void> tapProductCard(String productName) async {
    final card = find
        .ancestor(
          of: find.text(productName),
          matching: find.byType(ProductCard),
        )
        .last;
    final topLeft = getTopLeft(card);
    await tapAt(topLeft + const Offset(24, 24));
  }

  Future<void> tapInkForText(String text) async {
    final ink = find
        .ancestor(of: find.text(text), matching: find.byType(InkWell))
        .last;
    final topLeft = getTopLeft(ink);
    await tapAt(topLeft + const Offset(18, 18));
    await pumpAndSettle();
  }
}

class _FakeSettingsStore implements AppSettingsStore {
  _FakeSettingsStore([this._settings = const AppSettings()]);

  AppSettings _settings;

  @override
  AppSettings readSettings() => _settings;

  @override
  Future<void> saveLocaleCode(String localeCode) async {
    _settings = _settings.copyWith(localeCode: localeCode);
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
  }

  @override
  Future<void> resetAppearanceSettings() async {
    _settings = const AppSettings();
  }
}

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this.catalog);

  final CatalogData catalog;
  Future<CatalogData>? nextResult;
  var loadCount = 0;

  @override
  Future<CatalogData> loadCatalog() {
    loadCount += 1;
    final result = nextResult;
    if (result != null) {
      nextResult = null;
      return result;
    }

    return Future<CatalogData>.value(catalog);
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
