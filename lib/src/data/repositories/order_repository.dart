import '../../core/errors.dart';
import '../models/cart.dart';
import '../models/order.dart';
import 'simulated_latency.dart';

export '../../core/errors.dart' show EmptyCartException, OrderFailedException;

abstract class OrderRepository {
  const OrderRepository();

  /// Enregistre la commande. Lève une [EmptyCartException] si [items] est
  /// vide, une [OrderFailedException] si le service la refuse.
  Future<Order> placeOrder({
    required List<CartItem> items,
    required ShippingAddress address,
    required PaymentMethod paymentMethod,
  });
}

/// Simule l'envoi d'une commande à un backend (paiement Mobile Money fictif).
class MockOrderRepository extends OrderRepository with SimulatedLatency {
  MockOrderRepository({
    this.latency = const Duration(milliseconds: 800),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  @override
  final Duration latency;

  /// Horloge injectable : numéros de commande et dates déterministes en test.
  final DateTime Function() _clock;

  @override
  Future<Order> placeOrder({
    required List<CartItem> items,
    required ShippingAddress address,
    required PaymentMethod paymentMethod,
  }) async {
    if (items.isEmpty) throw const EmptyCartException();
    await simulateLatency();
    final now = _clock();
    final subtotal = items.fold(0, (total, item) => total + item.subtotal);
    return Order(
      id: 'RS-${now.millisecondsSinceEpoch.toRadixString(36).toUpperCase()}',
      items: List.unmodifiable(items),
      pricing: OrderPricing(subtotal: subtotal),
      address: address,
      paymentMethod: paymentMethod,
      placedAt: now,
    );
  }
}
