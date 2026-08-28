import 'product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

class CartState {
  const CartState({this.items = const {}});

  final Map<String, CartItem> items;

  List<CartItem> get itemList => items.values.toList(growable: false);

  int get totalQuantity =>
      items.values.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      items.values.fold(0, (total, item) => total + item.subtotal);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({Map<String, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
