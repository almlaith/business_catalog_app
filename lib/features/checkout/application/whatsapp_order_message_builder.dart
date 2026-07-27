import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/utils/currency_formatter.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:business_catalog_app/features/checkout/application/order_type.dart';
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
  }) {
    final lines = <String>[
      'Hello ${business.businessName},',
      '',
      'I would like to place an order.',
      '',
      'Customer:',
      'Name: ${details.customerName.trim()}',
      'Phone: ${details.customerPhone.trim()}',
      'Order type: ${details.orderType.label}',
    ];

    final deliveryAddress = details.deliveryAddress?.trim();
    if (details.orderType == OrderType.delivery &&
        deliveryAddress != null &&
        deliveryAddress.isNotEmpty) {
      lines.add('Delivery address: $deliveryAddress');
    }

    lines
      ..add('')
      ..add('Items:');

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
      '${AppStrings.subtotal}: ${formatCurrency(cart.subtotal, currencyCode: business.currencyCode)}',
    );

    final notes = details.notes?.trim();
    if (notes != null && notes.isNotEmpty) {
      lines
        ..add('')
        ..add('Notes:')
        ..add(notes);
    }

    return lines.join('\n').trimRight();
  }
}
