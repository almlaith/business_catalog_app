import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
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
      appBar: AppBar(title: Text(context.l10n.checkoutTitle)),
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
        l10n: context.l10n,
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
        _showSnackBar(context.l10n.whatsappUnavailable);
        return;
      }

      setState(() => _isSubmitting = false);
      _showSnackBar(context.l10n.orderSent);
      await _confirmClearCart();
    } on FormatException {
      if (mounted) {
        _showSnackBar(context.l10n.invalidWhatsappNumber);
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
        title: Text(context.l10n.clearCartAfterOrderQuestion),
        content: Text(context.l10n.clearCartAfterOrderMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.keepCart),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.clear),
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
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: ListView(
        key: const ValueKey('checkout-scroll-view'),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          CheckoutOrderSummary(cart: cart, currencyCode: business.currencyCode),
          const SizedBox(height: AppSpacing.lg),
          _CheckoutSection(
            icon: Icons.person_outline,
            title: l10n.customerDetails,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: const ValueKey('checkout-name-field'),
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ).copyWith(labelText: l10n.customerName),
                  validator: FormValidators.requiredText(l10n.requiredField),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const ValueKey('checkout-phone-field'),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    border: OutlineInputBorder(),
                  ),
                  validator: FormValidators.requiredText(l10n.requiredField),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.orderType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<OrderType>(
                  segments: [
                    ButtonSegment(
                      value: OrderType.pickup,
                      label: Text(l10n.pickup),
                      icon: const Icon(Icons.shopping_bag_outlined),
                    ),
                    ButtonSegment(
                      value: OrderType.delivery,
                      label: Text(l10n.delivery),
                      icon: const Icon(Icons.local_shipping_outlined),
                    ),
                  ],
                  selected: {orderType},
                  onSelectionChanged: (values) {
                    onOrderTypeChanged(values.single);
                  },
                ),
                if (orderType == OrderType.delivery) ...[
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    key: const ValueKey('checkout-delivery-address-field'),
                    controller: deliveryAddressController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.deliveryAddress,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => FormValidators.requiredWhen(
                      value,
                      condition: orderType == OrderType.delivery,
                      message: l10n.requiredField,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const ValueKey('checkout-notes-field'),
                  controller: notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.orderNotes,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_outlined),
            label: Text(l10n.sendOrderViaWhatsapp),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.checkoutNotImplemented,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}
