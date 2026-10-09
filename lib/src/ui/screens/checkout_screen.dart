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
    final email = useTextEditingController();
    final street = useTextEditingController();
    final postalCode = useTextEditingController();
    final city = useTextEditingController();

    // Pré-remplit nom et e-mail depuis le profil dès qu'il est disponible.
    final user = ref.watch(userProfileProvider.select((u) => u.value));
    useEffect(() {
      if (user != null) {
        if (fullName.text.isEmpty) fullName.text = user.name;
        if (email.text.isEmpty) email.text = user.email;
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
              email: email.text.trim(),
              street: street.text.trim(),
              postalCode: postalCode.text.trim(),
              city: city.text.trim(),
            ),
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
            padding: const EdgeInsets.all(16),
            children: [
              _Field(
                controller: fullName,
                label: l10n.fieldFullName,
                validator: validate(Validators.fullName),
                autofillHints: const [AutofillHints.name],
                textCapitalization: TextCapitalization.words,
              ),
              _Field(
                controller: email,
                label: l10n.fieldEmail,
                validator: validate(Validators.email),
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
              ),
              _Field(
                controller: street,
                label: l10n.fieldStreet,
                validator: validate(Validators.required),
                autofillHints: const [AutofillHints.streetAddressLine1],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _Field(
                      controller: postalCode,
                      label: l10n.fieldPostalCode,
                      validator: validate(Validators.postalCode),
                      autofillHints: const [AutofillHints.postalCode],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _Field(
                      controller: city,
                      label: l10n.fieldCity,
                      validator: validate(Validators.required),
                      autofillHints: const [AutofillHints.addressCity],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => submit(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Semantics(
                header: true,
                child: Text(
                  l10n.orderSummary,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              OrderSummary(pricing: pricing),
              const SizedBox(height: 16),
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
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
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
                : Text(
                    l10n.placeOrder(context.formatPrice(pricing.totalInCents)),
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
    this.autofillHints,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: validator,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
