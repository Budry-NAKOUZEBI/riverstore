import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/models/user_profile.dart';
import 'package:riverstore/src/data/repositories/order_repository.dart';
import 'package:riverstore/src/data/repositories/product_repository.dart';
import 'package:riverstore/src/data/repositories/user_repository.dart';

import 'fixtures.dart';

/// Repository contrôlable : renvoie la liste fournie ou l'erreur configurée,
/// peut être bloqué par [gate] et compte les appels.
class FakeProductRepository implements ProductRepository {
  FakeProductRepository([List<Product>? products])
    : products = products ?? testProducts;

  List<Product> products;
  Object? error;
  Completer<void>? gate;
  int calls = 0;

  @override
  Future<List<Product>> fetchProducts() async {
    calls++;
    if (gate != null) await gate!.future;
    if (error != null) throw error!;
    return products;
  }
}

class FakeUserRepository implements UserRepository {
  @override
  Future<UserProfile> fetchCurrentUser() async => testUser;
}

class OrderRepositoryMock extends Mock implements OrderRepository {}

/// Repository de commande réel mais sans latence.
OrderRepository instantOrderRepository() =>
    MockOrderRepository(latency: Duration.zero);
