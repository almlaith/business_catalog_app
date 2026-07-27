import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:business_catalog_app/features/checkout/application/order_type.dart';
import 'package:business_catalog_app/l10n/generated/app_localizations.dart';
import 'package:business_catalog_app/models/business_config.dart';

class WhatsAppOrderDetails {
  const WhatsAppOrderDetails({
    required this.customerName,
    required this.customerPhone,
    required this.orderType,
    this.deliveryAddress,
    this.notes,
  });

  final String customerName;
  final String customerPhone;
  final OrderType orderType;
  final String? deliveryAddress;
  final String? notes;
}

class WhatsAppOrderMessageBuilder {
  const WhatsAppOrderMessageBuilder();

  String build({
    required BusinessConfig business,
    required CartState cart,
    required WhatsAppOrderDetails details,
    required AppLocalizations l10n,
  }) {
    final lines = <String>[
      l10n.orderMessageGreeting(business.businessName),
      '',
      l10n.orderMessageIntro,
      '',
      l10n.orderMessageCustomerSection,
      '${l10n.orderMessageName}: ${details.customerName.trim()}',
      '${l10n.orderMessagePhone}: ${details.customerPhone.trim()}',
      '${l10n.orderMessageOrderType}: ${details.orderType.label(l10n)}',
    ];

    final deliveryAddress = details.deliveryAddress?.trim();
    if (details.orderType == OrderType.delivery &&
        deliveryAddress != null &&
        deliveryAddress.isNotEmpty) {
      lines.add('${l10n.orderMessageDeliveryAddress}: $deliveryAddress');
    }

    lines
      ..add('')
      ..add(l10n.orderMessageItems);

    for (final indexedItem in cart.items.indexed) {
      final index = indexedItem.$1 + 1;
      final item = indexedItem.$2;

      lines
        ..add('$index. ${item.product.name}')
        ..add(
          '   ${item.quantity} x ${formatCurrency(item.product.price, currencyCode: business.currencyCode)} = ${formatCurrency(item.lineTotal, currencyCode: business.currencyCode)}',
        )
        ..add('');
    }

    lines.add(
      '${l10n.subtotal}: ${formatCurrency(cart.subtotal, currencyCode: business.currencyCode)}',
    );

    final notes = details.notes?.trim();
    if (notes != null && notes.isNotEmpty) {
      lines
        ..add('')
        ..add(l10n.orderMessageNotes)
        ..add(notes);
    }

    return lines.join('\n').trimRight();
  }
}
