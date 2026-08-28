import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:riverstore/src/data/models/product.dart';
import 'package:riverstore/src/data/repositories/product_repository.dart';
import 'package:riverstore/src/providers/core_providers.dart';
import 'package:riverstore/src/providers/product_providers.dart';
import 'package:riverstore/src/ui/screens/catalog_screen.dart';

class _FakeProductRepository implements ProductRepository {
  const _FakeProductRepository();

  @override
  Future<List<Product>> fetchProducts() async {
    return const [
      Product(
        id: 'p1',
        name: 'Casque audio',
        description: 'd',
        price: 79.9,
        category: 'Électronique',
        imageUrl: 'https://example.com/a.png',
        rating: 4.7,
        stock: 15,
      ),
      Product(
        id: 'p2',
        name: 'Sneakers running',
        description: 'd',
        price: 89,
        category: 'Chaussures',
        imageUrl: 'https://example.com/b.png',
        rating: 4.5,
        stock: 8,
      ),
    ];
  }
}

void main() {
  testWidgets('CatalogScreen shows a loading indicator then the product grid',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          productRepositoryProvider.overrideWithValue(const _FakeProductRepository()),
        ],
        child: const MaterialApp(home: CatalogScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Casque audio'), findsOneWidget);
    expect(find.text('Sneakers running'), findsOneWidget);
  });
}
