import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/validation/form_validators.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/features/cart/application/cart_controller.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/checkout/application/order_type.dart';
import 'package:business_catalog_app/features/checkout/application/whatsapp_order_launcher.dart';
import 'package:business_catalog_app/features/checkout/application/whatsapp_order_message_builder.dart';
import 'package:business_catalog_app/features/checkout/widgets/checkout_order_summary.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  var _orderType = OrderType.pickup;
  var _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _deliveryAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartControllerProvider);
    final catalogState = ref.watch(catalogDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.checkoutTitle)),
      body: SafeArea(
        child: catalogState.when(
          loading: () => const AppLoadingState(),
          error: (error, stackTrace) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(catalogDataProvider),
          ),
          data: (catalog) => _CheckoutContent(
            cart: cart,
            business: catalog.business,
            formKey: _formKey,
            nameController: _nameController,
            phoneController: _phoneController,
            notesController: _notesController,
            deliveryAddressController: _deliveryAddressController,
            orderType: _orderType,
            isSubmitting: _isSubmitting,
            onOrderTypeChanged: (orderType) {
              setState(() => _orderType = orderType);
            },
            onSubmit: cart.isEmpty || _isSubmitting
                ? null
                : () => _submitOrder(catalog.business, cart),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder(BusinessConfig business, CartState cart) async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final details = WhatsAppOrderDetails(
        customerName: _nameController.text,
        customerPhone: _phoneController.text,
        orderType: _orderType,
        deliveryAddress: _deliveryAddressController.text,
        notes: _notesController.text,
      );
      final message = const WhatsAppOrderMessageBuilder().build(
        business: business,
        cart: cart,
        details: details,
      );
      final launched = await ref
          .read(whatsappOrderLauncherProvider)
          .launchOrder(
            whatsappNumber: business.whatsappNumber,
            message: message,
          );

      if (!mounted) {
        return;
      }

      if (!launched) {
        _showSnackBar(AppStrings.whatsappUnavailable);
        return;
      }

      setState(() => _isSubmitting = false);
      _showSnackBar(AppStrings.orderSent);
      await _confirmClearCart();
    } on FormatException {
      if (mounted) {
        _showSnackBar(AppStrings.invalidWhatsappNumber);
      }
    } finally {
      if (mounted && _isSubmitting) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _confirmClearCart() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.clearCartAfterOrderQuestion),
        content: const Text(AppStrings.clearCartAfterOrderMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.keepCart),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.clear),
          ),
        ],
      ),
    );

    if (shouldClear ?? false) {
      ref.read(cartControllerProvider.notifier).clear();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CheckoutContent extends StatelessWidget {
  const _CheckoutContent({
    required this.cart,
    required this.business,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.notesController,
    required this.deliveryAddressController,
    required this.orderType,
    required this.isSubmitting,
    required this.onOrderTypeChanged,
    required this.onSubmit,
  });

  final CartState cart;
  final BusinessConfig business;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final TextEditingController deliveryAddressController;
  final OrderType orderType;
  final bool isSubmitting;
  final ValueChanged<OrderType> onOrderTypeChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: ListView(
        key: const ValueKey('checkout-scroll-view'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          CheckoutOrderSummary(cart: cart, currencyCode: business.currencyCode),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.customerDetails,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('checkout-name-field'),
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: AppStrings.customerName,
                      border: OutlineInputBorder(),
                    ),
                    validator: FormValidators.requiredText,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('checkout-phone-field'),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: AppStrings.phoneNumber,
                      border: OutlineInputBorder(),
                    ),
                    validator: FormValidators.requiredText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.orderType,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<OrderType>(
                    segments: const [
                      ButtonSegment(
                        value: OrderType.pickup,
                        label: Text(AppStrings.pickup),
                        icon: Icon(Icons.shopping_bag_outlined),
                      ),
                      ButtonSegment(
                        value: OrderType.delivery,
                        label: Text(AppStrings.delivery),
                        icon: Icon(Icons.local_shipping_outlined),
                      ),
                    ],
                    selected: {orderType},
                    onSelectionChanged: (values) {
                      onOrderTypeChanged(values.single);
                    },
                  ),
                  if (orderType == OrderType.delivery) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('checkout-delivery-address-field'),
                      controller: deliveryAddressController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.deliveryAddress,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => FormValidators.requiredWhen(
                        value,
                        condition: orderType == OrderType.delivery,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('checkout-notes-field'),
                    controller: notesController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: AppStrings.orderNotes,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_outlined),
            label: const Text(AppStrings.sendOrderViaWhatsapp),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.checkoutNotImplemented,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
