import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverstore/src/app.dart';
import 'package:riverstore/src/bootstrap.dart';
import 'package:riverstore/src/data/models/app_settings.dart';
import 'package:riverstore/src/data/repositories/favorites_storage.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/providers/cart_providers.dart';
import 'package:riverstore/src/providers/product_providers.dart';
import 'package:riverstore/src/providers/settings_providers.dart';
import 'package:riverstore/src/router/app_router.dart';
import 'package:riverstore/src/router/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Génère les captures du README (désactivé par défaut) :
/// `flutter test integration_test/screenshots_test.dart -d linux \
///   --dart-define=SCREENSHOT_DIR=$PWD/docs/screenshots`
const _outputDir = String.fromEnvironment('SCREENSHOT_DIR');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture README screenshots', skip: _outputDir.isEmpty, (
    tester,
  ) async {
    // Format téléphone : 390 × 844 dp.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      SettingsStorage.languageKey: 'fr',
      SettingsStorage.themeModeKey: 'light',
      FavoritesStorage.key: ['p3', 'p5'],
    });
    await tester.pumpWidget(
      buildApp(preferences: await SharedPreferences.getInstance()),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(RiverStoreApp)),
    );
    final router = container.read(routerProvider);

    Future<void> go(String location, String name) async {
      router.go(location);
      await _capture(tester, name);
    }

    await _capture(tester, '01_catalog');
    await go(AppRoutes.catalogProduct('p5'), '02_product_detail');

    final products = await container.read(productsProvider.future);
    container.read(cartProvider.notifier)
      ..addProduct(products[4])
      ..addProduct(products[8], quantity: 2)
      ..addProduct(products[1]);
    await go(AppRoutes.cart, '03_cart');
    await go(AppRoutes.checkout, '04_checkout');
    await go(AppRoutes.favorites, '05_favorites');
    await go(AppRoutes.profile, '06_profile');

    final settings = container.read(settingsProvider.notifier);
    await settings.setLanguage(AppLanguage.en);
    await settings.setThemeMode(ThemeMode.dark);
    await go(AppRoutes.settings, '07_settings_en_dark');
    await go(AppRoutes.catalog, '08_catalog_en_dark');
  });
}

Future<void> _capture(WidgetTester tester, String name) async {
  // Laisse le temps aux images réseau d'arriver et au fondu de se terminer.
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
  await tester.pumpAndSettle();

  final renderView = tester.binding.renderViews.first;
  final layer = renderView.debugLayer! as OffsetLayer;
  // 1170 × 2532 px physiques réduits à 780 × 1688.
  final image = await layer.toImage(renderView.paintBounds, pixelRatio: 2 / 3);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File('$_outputDir/$name.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!.buffer.asUint8List());
}
