import '../models/cart.dart';
import '../models/order.dart';

class EmptyCartException implements Exception {
  const EmptyCartException();
}

abstract interface class OrderRepository {
  Future<Order> placeOrder({
    required List<CartItem> items,
    required ShippingAddress address,
  });
}

/// Simule l'envoi d'une commande à un backend.
class MockOrderRepository implements OrderRepository {
  MockOrderRepository({
    this.latency = const Duration(milliseconds: 800),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration latency;
  final DateTime Function() _clock;

  @override
  Future<Order> placeOrder({
    required List<CartItem> items,
    required ShippingAddress address,
  }) async {
    if (items.isEmpty) throw const EmptyCartException();
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final now = _clock();
    final subtotal = items.fold(
      0,
      (total, item) => total + item.subtotalInCents,
    );
    return Order(
      id: 'RS-${now.millisecondsSinceEpoch.toRadixString(36).toUpperCase()}',
      items: List.unmodifiable(items),
      pricing: OrderPricing(subtotalInCents: subtotal),
      address: address,
      placedAt: now,
    );
  }
}
