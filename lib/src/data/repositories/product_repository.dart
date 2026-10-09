import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/errors.dart';
import '../models/product.dart';
import 'simulated_latency.dart';

export '../../core/errors.dart'
    show CatalogLoadException, ProductNotFoundException;

/// Contrat d'accès au catalogue. L'interface ne dépend que de cette
/// abstraction : on peut la remplacer par une API REST sans toucher l'UI.
abstract class ProductRepository {
  const ProductRepository();

  /// Renvoie tout le catalogue, ou lève une [CatalogLoadException].
  Future<List<Product>> fetchProducts();
}

/// Charge le catalogue depuis un fichier JSON embarqué dans les assets,
/// avec un délai simulant un appel réseau.
class AssetProductRepository extends ProductRepository with SimulatedLatency {
  const AssetProductRepository({
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 400),
  }) : _bundle = bundle;

  static const assetPath = 'assets/data/products.json';

  final AssetBundle? _bundle;

  @override
  final Duration latency;

  @override
  Future<List<Product>> fetchProducts() async {
    await simulateLatency();
    final String raw;
    try {
      raw = await (_bundle ?? rootBundle).loadString(assetPath);
    } catch (error) {
      // `rootBundle` signale un asset manquant par une FlutterError (qui
      // n'est pas une Exception) : on intercepte tout et on encapsule.
      throw CatalogLoadException(
        'Lecture de $assetPath impossible',
        cause: error,
      );
    }
    return parseProducts(raw);
  }

  /// Décodage isolé dans une fonction pure pour être testé sans assets.
  /// Toute donnée mal formée devient une [CatalogLoadException].
  static List<Product> parseProducts(String raw) {
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((entry) => Product.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false);
    } on Object catch (error) {
      if (error is AppException) rethrow;
      throw CatalogLoadException('Catalogue JSON invalide', cause: error);
    }
  }
}
