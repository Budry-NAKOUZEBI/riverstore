import 'package:riverstore/src/data/models/localized_text.dart';
import 'package:riverstore/src/data/models/order.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/models/product_category.dart';
import 'package:riverstore/src/data/models/user_profile.dart';

Product buildProduct({
  String id = 'p1',
  String nameFr = 'Pagne wax',
  String nameEn = 'Wax print fabric',
  int price = 18000,
  ProductCategory category = ProductCategory.fashion,
  double rating = 4.7,
  int stock = 15,
}) {
  return Product(
    id: id,
    name: LocalizedText({'fr': nameFr, 'en': nameEn}),
    description: const LocalizedText({
      'fr': 'Description',
      'en': 'Description',
    }),
    price: price,
    category: category,
    imageUrl: 'https://example.com/$id.png',
    thumbnailUrl: 'https://example.com/$id-thumb.png',
    rating: rating,
    stock: stock,
  );
}

/// 18 000 FCFA, mode, 15 en stock.
final pagne = buildProduct();

/// 12 500 FCFA, chaussures, seulement 3 en stock.
final sandals = buildProduct(
  id: 'p2',
  nameFr: 'Sandales en cuir',
  nameEn: 'Leather sandals',
  price: 12500,
  category: ProductCategory.shoes,
  rating: 4.5,
  stock: 3,
);

/// 14 000 FCFA, maison.
final pot = buildProduct(
  id: 'p3',
  nameFr: 'Marmite en inox',
  nameEn: 'Stainless steel pot',
  price: 14000,
  category: ProductCategory.home,
  rating: 4.0,
  stock: 18,
);

/// 250 000 FCFA, high-tech, en rupture de stock, nom accentué.
final solarKit = buildProduct(
  id: 'p4',
  nameFr: "Kit d'éclairage solaire",
  nameEn: 'Solar lighting kit',
  price: 250000,
  category: ProductCategory.electronics,
  rating: 4.1,
  stock: 0,
);

final testProducts = [pagne, sandals, pot, solarKit];

final testUser = UserProfile(
  id: 'u1',
  name: 'Grâce Mabiala',
  email: 'grace@example.cg',
  phone: '06 612 34 56',
  city: 'Brazzaville',
  memberSince: DateTime(2023, 3, 12),
  totalOrders: 8,
);

const testAddress = ShippingAddress(
  fullName: 'Grâce Mabiala',
  phone: '06 612 34 56',
  city: 'Brazzaville',
  district: 'Bacongo',
  street: 'Rue Mbochis, n° 12, près du marché Total',
);
