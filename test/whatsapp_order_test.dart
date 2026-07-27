import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/features/cart/domain/cart_item.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:business_catalog_app/features/checkout/application/order_type.dart';
import 'package:business_catalog_app/features/checkout/application/whatsapp_order_launcher.dart';
import 'package:business_catalog_app/features/checkout/application/whatsapp_order_message_builder.dart';
import 'package:business_catalog_app/l10n/generated/app_localizations_en.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  late BusinessConfig business;
  late CartState cart;
  final l10n = AppLocalizationsEn();

  setUpAll(() {
    final rawJson = File(AppAssets.catalogData).readAsStringSync();
    final catalog = CatalogData.fromJson(
      jsonDecode(rawJson) as Map<String, Object?>,
    );
    business = catalog.business;
    cart = CartState(
      items: [
        CartItem(product: catalog.products.first, quantity: 2),
        CartItem(product: catalog.products[1], quantity: 1),
      ],
    );
  });

  test('normalizes WhatsApp numbers', () {
    final launcher = WhatsAppOrderLauncher(
      externalLinkLauncher: _FakeExternalLinkLauncher(),
    );

    expect(
      launcher.normalizeWhatsAppNumber('+1 (555) 123-4567'),
      '15551234567',
    );
  });

  test('generates pickup message', () {
    final message = const WhatsAppOrderMessageBuilder().build(
      business: business,
      cart: cart,
      details: const WhatsAppOrderDetails(
        customerName: 'John Smith',
        customerPhone: '+1 555 123 4567',
        orderType: OrderType.pickup,
      ),
      l10n: l10n,
    );

    expect(message, contains('Hello Catalogly Kitchen,'));
    expect(message, contains('Name: John Smith'));
    expect(message, contains('Order type: Pickup'));
    expect(message, contains(r'2 x $7.50 = $15.00'));
    expect(message, contains(r'Subtotal: $21.25'));
    expect(message, isNot(contains('Delivery address:')));
  });

  test('generates delivery message', () {
    final message = const WhatsAppOrderMessageBuilder().build(
      business: business,
      cart: cart,
      details: const WhatsAppOrderDetails(
        customerName: 'John Smith',
        customerPhone: '+1 555 123 4567',
        orderType: OrderType.delivery,
        deliveryAddress: '42 Example Street',
      ),
      l10n: l10n,
    );

    expect(message, contains('Order type: Delivery'));
    expect(message, contains('Delivery address: 42 Example Street'));
  });

  test('omits optional notes when blank', () {
    final message = const WhatsAppOrderMessageBuilder().build(
      business: business,
      cart: cart,
      details: const WhatsAppOrderDetails(
        customerName: 'John Smith',
        customerPhone: '+1 555 123 4567',
        orderType: OrderType.pickup,
        notes: '   ',
      ),
      l10n: l10n,
    );

    expect(message, isNot(contains('Notes:')));
  });

  test('includes optional notes when provided', () {
    final message = const WhatsAppOrderMessageBuilder().build(
      business: business,
      cart: cart,
      details: const WhatsAppOrderDetails(
        customerName: 'John Smith',
        customerPhone: '+1 555 123 4567',
        orderType: OrderType.pickup,
        notes: 'Please call on arrival.',
      ),
      l10n: l10n,
    );

    expect(message, contains('Notes:\nPlease call on arrival.'));
  });

  test('rejects empty or invalid WhatsApp numbers', () {
    final launcher = WhatsAppOrderLauncher(
      externalLinkLauncher: _FakeExternalLinkLauncher(),
    );

    expect(() => launcher.normalizeWhatsAppNumber(''), throwsFormatException);
    expect(
      () => launcher.normalizeWhatsAppNumber('abc'),
      throwsFormatException,
    );
    expect(
      () => launcher.normalizeWhatsAppNumber('123'),
      throwsFormatException,
    );
  });
}

class _FakeExternalLinkLauncher implements ExternalLinkLauncher {
  @override
  Future<bool> canLaunch(Uri uri) async => true;

  @override
  Future<bool> launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    return true;
  }
}
