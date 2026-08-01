import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/validation/form_validators.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_confirmation_dialog.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
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
      body: AuroraBackground(
        bottomSafeGlow: true,
        child: SafeArea(
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
      ),
    );
  }

  Future<void> _submitOrder(BusinessConfig business, CartState cart) async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      showAppFeedback(
        context,
        type: AppFeedbackType.warning,
        title: context.l10n.invalidFormTitle,
        message: context.l10n.invalidFormMessage,
      );
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
        _showFeedback(
          type: AppFeedbackType.error,
          title: context.l10n.errorTitle,
          message: context.l10n.whatsappUnavailable,
        );
        return;
      }

      setState(() => _isSubmitting = false);
      _showFeedback(
        type: AppFeedbackType.success,
        title: context.l10n.successTitle,
        message: context.l10n.orderSent,
      );
      await _confirmClearCart();
    } on FormatException {
      if (mounted) {
        _showFeedback(
          type: AppFeedbackType.error,
          title: context.l10n.errorTitle,
          message: context.l10n.invalidWhatsappNumber,
        );
      }
    } finally {
      if (mounted && _isSubmitting) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _confirmClearCart() async {
    final shouldClear = await showAppConfirmationDialog(
      context: context,
      icon: Icons.shopping_bag_outlined,
      title: context.l10n.clearCartAfterOrderQuestion,
      message: context.l10n.clearCartAfterOrderMessage,
      cancelLabel: context.l10n.keepCart,
      confirmLabel: context.l10n.clear,
      isDestructive: true,
    );

    if (shouldClear) {
      ref.read(cartControllerProvider.notifier).clear();
    }
  }

  void _showFeedback({
    required AppFeedbackType type,
    required String title,
    required String message,
  }) {
    showAppFeedback(context, type: type, title: title, message: message);
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
          128,
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
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ).copyWith(labelText: l10n.customerName),
                  validator: FormValidators.requiredText(l10n.requiredField),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const ValueKey('checkout-phone-field'),
                  controller: phoneController,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
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
                _OrderTypeSelector(
                  orderType: orderType,
                  onChanged: onOrderTypeChanged,
                ),
                AnimatedSwitcher(
                  duration: AppDurations.medium,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: orderType == OrderType.delivery
                      ? Padding(
                          key: const ValueKey('delivery-address-visible'),
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: TextFormField(
                            key: const ValueKey(
                              'checkout-delivery-address-field',
                            ),
                            controller: deliveryAddressController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: l10n.deliveryAddress,
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                            ),
                            validator: (value) => FormValidators.requiredWhen(
                              value,
                              condition: orderType == OrderType.delivery,
                              message: l10n.requiredField,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('delivery-address-hidden'),
                        ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const ValueKey('checkout-notes-field'),
                  controller: notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.orderNotes,
                    prefixIcon: const Icon(Icons.notes_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AuroraGradientFilledButton(
            onPressed: onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
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

    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AuroraIconContainer(icon: icon),
              const SizedBox(width: AppSpacing.md),
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
    );
  }
}

class _OrderTypeSelector extends StatelessWidget {
  const _OrderTypeSelector({required this.orderType, required this.onChanged});

  final OrderType orderType;
  final ValueChanged<OrderType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: _OrderTypeOption(
                label: l10n.pickup,
                icon: Icons.shopping_bag_outlined,
                selected: orderType == OrderType.pickup,
                onTap: () => onChanged(OrderType.pickup),
              ),
            ),
            Expanded(
              child: _OrderTypeOption(
                label: l10n.delivery,
                icon: Icons.local_shipping_outlined,
                selected: orderType == OrderType.delivery,
                onTap: () => onChanged(OrderType.delivery),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTypeOption extends StatelessWidget {
  const _OrderTypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        gradient: selected ? AuroraGradients.primary : null,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: selected
            ? AuroraShadows.glow(colorScheme.primary, opacity: 0.16, blur: 18)
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppIconSizes.sm,
                color: selected ? Colors.white : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
