import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductNotFoundException implements Exception {
  const ProductNotFoundException(this.productId);

  final String productId;

  @override
  String toString() => 'ProductNotFoundException($productId)';
}

abstract interface class ProductRepository {
  Future<List<Product>> fetchProducts();
}

/// Charge le catalogue depuis un fichier JSON embarqué dans les assets,
/// avec un délai simulant un appel réseau.
class AssetProductRepository implements ProductRepository {
  const AssetProductRepository({
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 400),
  }) : _bundle = bundle;

  static const assetPath = 'assets/data/products.json';

  final AssetBundle? _bundle;
  final Duration latency;

  @override
  Future<List<Product>> fetchProducts() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final raw = await (_bundle ?? rootBundle).loadString(assetPath);
    return parseProducts(raw);
  }

  /// Décodage isolé dans une fonction pure pour être testé sans assets.
  static List<Product> parseProducts(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => Product.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);
  }
}
