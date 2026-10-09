import 'package:riverstore/src/data/models/localized_text.dart';
import 'package:riverstore/src/data/models/order.dart';
import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/models/product_category.dart';
import 'package:riverstore/src/data/models/user_profile.dart';

Product buildProduct({
  String id = 'p1',
  String nameFr = 'Casque audio',
  String nameEn = 'Headphones',
  int priceInCents = 7990,
  ProductCategory category = ProductCategory.electronics,
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
    priceInCents: priceInCents,
    category: category,
    imageUrl: 'https://example.com/$id.png',
    thumbnailUrl: 'https://example.com/$id-thumb.png',
    rating: rating,
    stock: stock,
  );
}

final headphones = buildProduct();

final sneakers = buildProduct(
  id: 'p2',
  nameFr: 'Sneakers running',
  nameEn: 'Running sneakers',
  priceInCents: 8900,
  category: ProductCategory.shoes,
  rating: 4.5,
  stock: 3,
);

final lamp = buildProduct(
  id: 'p3',
  nameFr: 'Lampe de bureau',
  nameEn: 'Desk lamp',
  priceInCents: 2490,
  category: ProductCategory.home,
  rating: 4.0,
  stock: 18,
);

final screen = buildProduct(
  id: 'p4',
  nameFr: 'Écran incurvé',
  nameEn: 'Curved monitor',
  priceInCents: 19900,
  category: ProductCategory.electronics,
  rating: 4.1,
  stock: 0,
);

final testProducts = [headphones, sneakers, lamp, screen];

final testUser = UserProfile(
  id: 'u1',
  name: 'Camille Dubois',
  email: 'camille@example.com',
  avatarUrl: 'https://example.com/avatar.png',
  memberSince: DateTime(2023, 3, 12),
  totalOrders: 8,
);

const testAddress = ShippingAddress(
  fullName: 'Camille Dubois',
  email: 'camille@example.com',
  street: '12 rue des Lilas',
  postalCode: '75011',
  city: 'Paris',
);
