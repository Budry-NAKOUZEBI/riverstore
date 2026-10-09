import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/order.dart';
import '../data/repositories/order_repository.dart';
import 'cart_providers.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => MockOrderRepository(),
);

/// Commandes passées pendant la session (la plus récente en premier).
class OrderHistoryNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() => const [];

  void add(Order order) => state = [order, ...state];
}

final orderHistoryProvider =
    NotifierProvider<OrderHistoryNotifier, List<Order>>(
      OrderHistoryNotifier.new,
    );

final orderByIdProvider = Provider.family<Order?, String>((ref, orderId) {
  for (final order in ref.watch(orderHistoryProvider)) {
    if (order.id == orderId) return order;
  }
  return null;
});

/// Pilote l'envoi de la commande : état `null` au repos, chargement pendant
/// l'appel, puis la commande créée (ou l'erreur).
class CheckoutController extends AsyncNotifier<Order?> {
  @override
  Future<Order?> build() async => null;

  Future<Order?> submit(
    ShippingAddress address, {
    required PaymentMethod paymentMethod,
  }) async {
    final items = ref.read(cartProvider).itemList;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(orderRepositoryProvider)
          .placeOrder(
            items: items,
            address: address,
            paymentMethod: paymentMethod,
          ),
    );
    if (!ref.mounted) return result.value;
    final order = result.value;
    if (order != null) {
      ref.read(orderHistoryProvider.notifier).add(order);
      ref.read(cartProvider.notifier).clear();
    }
    state = result;
    return order;
  }
}

final checkoutControllerProvider =
    AsyncNotifierProvider.autoDispose<CheckoutController, Order?>(
      CheckoutController.new,
    );
