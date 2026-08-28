import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverstore/src/providers/core_providers.dart';
import 'package:riverstore/src/providers/favorites_providers.dart';

void main() {
  group('FavoritesNotifier', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    ProviderContainer makeContainer() {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('toggle adds and then removes a product id', () async {
      final container = makeContainer();
      final notifier = container.read(favoritesProvider.notifier);

      await notifier.toggle('p1');
      expect(container.read(favoritesProvider), {'p1'});

      await notifier.toggle('p1');
      expect(container.read(favoritesProvider), isEmpty);
    });

    test('favorites are persisted to SharedPreferences', () async {
      final container = makeContainer();
      await container.read(favoritesProvider.notifier).toggle('p2');

      expect(prefs.getStringList('favorite_product_ids'), ['p2']);
    });

    test('isFavoriteProvider reflects current state', () async {
      final container = makeContainer();
      await container.read(favoritesProvider.notifier).toggle('p3');

      expect(container.read(isFavoriteProvider('p3')), isTrue);
      expect(container.read(isFavoriteProvider('p4')), isFalse);
    });
  });
}
