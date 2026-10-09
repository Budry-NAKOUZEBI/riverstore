import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../ui/l10n_extensions.dart';
import '../ui/screens/cart_screen.dart';
import '../ui/screens/catalog_screen.dart';
import '../ui/screens/checkout_screen.dart';
import '../ui/screens/favorites_screen.dart';
import '../ui/screens/order_confirmation_screen.dart';
import '../ui/screens/product_detail_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/shell/main_shell.dart';
import '../ui/widgets/state_views.dart';
import 'app_routes.dart';

/// Routeur créé une seule fois par `ProviderScope` (une instance neuve par
/// test, sans clé globale partagée).
final routerProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  GoRoute productRoute() => GoRoute(
    path: 'product/:id',
    builder: (context, state) =>
        ProductDetailScreen(productId: state.pathParameters['id']!),
  );

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.catalog,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.catalog,
                builder: (context, state) => const CatalogScreen(),
                routes: [productRoute()],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const FavoritesScreen(),
                routes: [productRoute()],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const CartScreen(),
                routes: [
                  GoRoute(
                    path: 'checkout',
                    builder: (context, state) => const CheckoutScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/order/:orderId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            OrderConfirmationScreen(orderId: state.pathParameters['orderId']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: EmptyState(
        icon: Icons.explore_off_outlined,
        message: context.l10n.pageNotFound,
        actionLabel: context.l10n.backToCatalog,
        onAction: () => context.go(AppRoutes.catalog),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});
