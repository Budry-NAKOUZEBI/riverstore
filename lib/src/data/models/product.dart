import 'package:flutter/foundation.dart';

import 'localized_text.dart';
import 'product_category.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInCents,
    required this.category,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl'] as String;
    return Product(
      id: json['id'] as String,
      name: LocalizedText.fromJson(json['name']),
      description: LocalizedText.fromJson(json['description']),
      // Les montants sont manipulés en centimes pour éviter les erreurs
      // d'arrondi des `double` lors des calculs de totaux.
      priceInCents: ((json['price'] as num) * 100).round(),
      category: ProductCategory.values.byName(json['category'] as String),
      imageUrl: imageUrl,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? imageUrl,
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
    );
  }

  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final int priceInCents;
  final ProductCategory category;

  /// Image pleine résolution (écran de détail).
  final String imageUrl;

  /// Image réduite utilisée dans les grilles et listes.
  final String thumbnailUrl;
  final double rating;
  final int stock;

  bool get inStock => stock > 0;

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product($id, ${name.resolve('fr')})';
}
