import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/core/errors.dart';
import 'package:riverstore/src/data/models/app_settings.dart';
import 'package:riverstore/src/data/repositories/favorites_storage.dart';
import 'package:riverstore/src/data/repositories/key_value_store.dart';
import 'package:riverstore/src/data/repositories/product_repository.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/ui/l10n_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bundle d'assets qui échoue comme `rootBundle` quand un fichier manque.
class _MissingAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) =>
      throw FlutterError('Unable to load asset: "$key".');
}

void main() {
  group('AppException hierarchy', () {
    final errors = <AppException>[
      const CatalogLoadException('json'),
      ProductNotFoundException('p42'),
      const EmptyCartException(),
      const OrderFailedException('refusée'),
    ];

    test('every business error is an Exception and keeps its cause', () {
      for (final error in errors) {
        expect(error, isA<Exception>());
      }
      const wrapped = CatalogLoadException('lecture', cause: 'disque');
      expect(wrapped.cause, 'disque');
      expect(wrapped.toString(), contains('CatalogLoadException'));
      expect(wrapped.toString(), contains('disque'));
    });

    test('each subtype maps to its own translated message', () {
      final fr = lookupAppLocalizations(const Locale('fr'));
      final messages = errors.map((e) => userMessageFor(e, fr)).toList();
      expect(messages, [
        fr.catalogError,
        fr.productNotFound,
        fr.cartEmpty,
        fr.orderFailed,
      ]);
      expect(userMessageFor(StateError('?'), fr), fr.errorUnexpected);
    });
  });

  group('AssetProductRepository errors', () {
    test('malformed JSON becomes a CatalogLoadException', () {
      expect(
        () => AssetProductRepository.parseProducts('{pas du json'),
        throwsA(isA<CatalogLoadException>()),
      );
      expect(
        () => AssetProductRepository.parseProducts('[{"id": "p1"}]'),
        throwsA(isA<CatalogLoadException>()),
      );
    });

    test('a missing asset becomes a CatalogLoadException with its cause', () {
      final repository = AssetProductRepository(
        bundle: _MissingAssetBundle(),
        latency: Duration.zero,
      );
      expect(
        repository.fetchProducts(),
        throwsA(
          isA<CatalogLoadException>().having(
            (e) => e.cause,
            'cause',
            isA<FlutterError>(),
          ),
        ),
      );
    });
  });

  group('KeyValueStore<T>', () {
    Future<SharedPreferences> prefs(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      return SharedPreferences.getInstance();
    }

    test('subclasses share the same generic contract', () async {
      final p = await prefs({});
      final stores = <KeyValueStore<Object>>[
        FavoritesStorage(p),
        SettingsStorage(p),
      ];
      expect(stores.map((s) => s.read()), [<String>{}, const AppSettings()]);
    });

    test('round-trips a value through write and read', () async {
      final store = FavoritesStorage(await prefs({}));
      await store.write({'p3', 'p1'});
      expect(store.read(), {'p1', 'p3'});
    });

    test('corrupted data falls back to the default value', () async {
      // Une chaîne là où une liste est attendue : getStringList échoue.
      final store = FavoritesStorage(
        await prefs({FavoritesStorage.key: 'corrompu'}),
      );
      expect(store.read(), isEmpty);
    });
  });
}
