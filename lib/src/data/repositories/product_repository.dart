import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductNotFoundException implements Exception {
  const ProductNotFoundException(this.productId);

  final String productId;

  @override
  String toString() =>
      'Aucun produit trouvé pour l\'identifiant "$productId".';
}

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
}

/// Repository de démonstration : charge le catalogue depuis un fichier
/// JSON embarqué dans les assets, avec un léger délai simulant un appel
/// réseau réel.
class MockProductRepository implements ProductRepository {
  const MockProductRepository({AssetBundle? bundle}) : _bundle = bundle;

  final AssetBundle? _bundle;
  static const _assetPath = 'assets/data/products.json';

  @override
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final bundle = _bundle ?? rootBundle;
    final raw = await bundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => Product.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);
  }
}
