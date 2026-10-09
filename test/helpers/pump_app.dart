import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:riverstore/l10n/app_localizations.dart';
import 'package:riverstore/src/app.dart';
import 'package:riverstore/src/providers/core_providers.dart';
import 'package:riverstore/src/providers/order_providers.dart';
import 'package:riverstore/src/providers/product_providers.dart';
import 'package:riverstore/src/providers/user_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

Future<List<Override>> defaultOverrides({
  Map<String, Object> preferences = const {},
  FakeProductRepository? productRepository,
}) async {
  SharedPreferences.setMockInitialValues(preferences);
  final prefs = await SharedPreferences.getInstance();
  return [
    sharedPreferencesProvider.overrideWithValue(prefs),
    productRepositoryProvider.overrideWithValue(
      productRepository ?? FakeProductRepository(),
    ),
    userRepositoryProvider.overrideWithValue(FakeUserRepository()),
    orderRepositoryProvider.overrideWithValue(instantOrderRepository()),
  ];
}

extension PumpApp on WidgetTester {
  /// Monte un widget isolé dans un `MaterialApp` localisé, avec les
  /// dépendances remplacées par des fakes.
  Future<ProviderContainer> pumpLocalized(
    Widget child, {
    Locale locale = const Locale('fr'),
    List<Override> overrides = const [],
    FakeProductRepository? productRepository,
  }) async {
    final base = await defaultOverrides(productRepository: productRepository);
    await pumpWidget(
      ProviderScope(
        overrides: [...base, ...overrides],
        retry: (_, _) => null,
        child: MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: child,
        ),
      ),
    );
    return ProviderScope.containerOf(element(find.byWidget(child)));
  }

  /// Monte l'application complète (routeur, thème, réglages).
  Future<ProviderContainer> pumpFullApp({
    Map<String, Object> preferences = const {},
    FakeProductRepository? productRepository,
  }) async {
    final overrides = await defaultOverrides(
      preferences: preferences,
      productRepository: productRepository,
    );
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        retry: (_, _) => null,
        child: const RiverStoreApp(),
      ),
    );
    await pumpAndSettle();
    return ProviderScope.containerOf(element(find.byType(RiverStoreApp)));
  }
}
