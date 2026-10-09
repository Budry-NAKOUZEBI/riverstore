import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/validators.dart';
import '../../data/models/order.dart';
import '../../providers/cart_providers.dart';
import '../../providers/order_providers.dart';
import '../../providers/user_providers.dart';
import '../../router/app_routes.dart';
import '../l10n_extensions.dart';
import '../widgets/order_summary.dart';
import '../widgets/state_views.dart';

class CheckoutScreen extends HookConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final fullName = useTextEditingController();
    final phone = useTextEditingController();
    final district = useTextEditingController();
    final street = useTextEditingController();
    final city = useState(deliveryCities.first);
    final payment = useState(PaymentMethod.mtnMobileMoney);

    // Pré-remplit nom, téléphone et ville depuis le profil.
    final user = ref.watch(userProfileProvider.select((u) => u.value));
    useEffect(() {
      if (user != null) {
        if (fullName.text.isEmpty) fullName.text = user.name;
        if (phone.text.isEmpty) phone.text = user.phone;
        if (deliveryCities.contains(user.city)) city.value = user.city;
      }
      return null;
    }, [user]);

    final checkout = ref.watch(checkoutControllerProvider);
    final pricing = ref.watch(cartPricingProvider);
    final cartIsEmpty = ref.watch(cartProvider.select((c) => c.isEmpty));
    final isSubmitting = checkout.isLoading;

    ref.listen(checkoutControllerProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.orderFailed)));
      }
    });

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final order = await ref
          .read(checkoutControllerProvider.notifier)
          .submit(
            ShippingAddress(
              fullName: fullName.text.trim(),
              phone: phone.text.trim(),
              city: city.value,
              district: district.text.trim(),
              street: street.text.trim(),
            ),
            paymentMethod: payment.value,
          );
      if (order != null && context.mounted) {
        context.go(AppRoutes.orderConfirmation(order.id));
      }
    }

    if (cartIsEmpty && !isSubmitting && checkout.value == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.checkoutTitle)),
        body: EmptyState(
          icon: Icons.shopping_cart_outlined,
          message: l10n.cartEmpty,
          actionLabel: l10n.startShopping,
          onAction: () => context.go(AppRoutes.catalog),
        ),
      );
    }

    String? Function(String?) validate(
      ValidationError? Function(String?) rule,
    ) =>
        (value) => rule(value)?.message(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: Form(
        key: formKey,
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _Section(
                icon: Icons.location_on_outlined,
                title: l10n.sectionDelivery,
                children: [
                  _Field(
                    controller: fullName,
                    label: l10n.fieldFullName,
                    validator: validate(Validators.fullName),
                    autofillHints: const [AutofillHints.name],
                    textCapitalization: TextCapitalization.words,
                  ),
                  _Field(
                    controller: phone,
                    label: l10n.fieldPhone,
                    hint: l10n.fieldPhoneHint,
                    validator: validate(Validators.phone),
                    autofillHints: const [AutofillHints.telephoneNumber],
                    keyboardType: TextInputType.phone,
                    prefixText: '+242 ',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                      LengthLimitingTextInputFormatter(17),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DropdownButtonFormField<String>(
                      initialValue: city.value,
                      decoration: InputDecoration(labelText: l10n.fieldCity),
                      items: [
                        for (final name in deliveryCities)
                          DropdownMenuItem(value: name, child: Text(name)),
                      ],
                      onChanged: (value) {
                        if (value != null) city.value = value;
                      },
                    ),
                  ),
                  _Field(
                    controller: district,
                    label: l10n.fieldDistrict,
                    hint: l10n.fieldDistrictHint,
                    validator: validate(Validators.required),
                    textCapitalization: TextCapitalization.words,
                  ),
                  _Field(
                    controller: street,
                    label: l10n.fieldStreet,
                    hint: l10n.fieldStreetHint,
                    validator: validate(Validators.required),
                    autofillHints: const [AutofillHints.streetAddressLine1],
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Section(
                icon: Icons.account_balance_wallet_outlined,
                title: l10n.sectionPayment,
                children: [
                  RadioGroup<PaymentMethod>(
                    groupValue: payment.value,
                    onChanged: (value) {
                      if (value != null) payment.value = value;
                    },
                    child: Column(
                      children: [
                        for (final method in PaymentMethod.values)
                          _PaymentOption(
                            method: method,
                            selected: payment.value == method,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.paymentNotice,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Section(
                icon: Icons.receipt_long_outlined,
                title: l10n.orderSummary,
                children: [OrderSummary(pricing: pricing)],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: isSubmitting ? null : submit,
            child: isSubmitting
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(l10n.placingOrder),
                    ],
                  )
                : Text(l10n.placeOrder(context.formatPrice(pricing.total))),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Row(
                children: [
                  Icon(icon, color: theme.colorScheme.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...children,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({required this.method, required this.selected});

  final PaymentMethod method;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    // Pastilles de couleur génériques (pas de logo de marque).
    final (badgeColor, badgeText, badgeForeground) = switch (method) {
      PaymentMethod.mtnMobileMoney => (
        const Color(0xFFFFCB05),
        'MTN',
        Colors.black,
      ),
      PaymentMethod.airtelMoney => (const Color(0xFFD7141A), 'A', Colors.white),
      PaymentMethod.cashOnDelivery => (colors.primary, 'F', colors.onPrimary),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RadioListTile<PaymentMethod>(
        value: method,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        tileColor: selected
            ? colors.primaryContainer.withValues(alpha: 0.35)
            : null,
        title: Text(method.label(l10n)),
        subtitle: Text(method.hint(l10n)),
        secondary: ExcludeSemantics(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: badgeColor,
            child: method == PaymentMethod.cashOnDelivery
                ? Icon(
                    Icons.payments_outlined,
                    color: badgeForeground,
                    size: 20,
                  )
                : Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeForeground,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.validator,
    this.hint,
    this.prefixText,
    this.autofillHints,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? prefixText;
  final FormFieldValidator<String> validator;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefixText,
        ),
        validator: validator,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
      ),
    );
  }
}
