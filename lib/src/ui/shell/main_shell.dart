import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/cart_providers.dart';
import '../l10n_extensions.dart';

/// Coque de navigation principale : barre du bas sur mobile, rail latéral
/// sur grand écran (≥ 840 dp). Chaque onglet conserve sa pile de navigation.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  static const railBreakpoint = 840.0;

  final StatefulNavigationShell navigationShell;

  void _onSelect(int index) => navigationShell.goBranch(
    index,
    // Re-toucher l'onglet actif revient à sa racine.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      (Icons.storefront_outlined, Icons.storefront, l10n.navCatalog),
      (Icons.favorite_border, Icons.favorite, l10n.navFavorites),
      (Icons.shopping_cart_outlined, Icons.shopping_cart, l10n.navCart),
      (Icons.person_outline, Icons.person, l10n.navProfile),
    ];
    const cartIndex = 2;

    Widget icon(int index, {required bool selected}) {
      final (outlined, filled, _) = destinations[index];
      final iconData = selected ? filled : outlined;
      return index == cartIndex ? _CartIcon(iconData) : Icon(iconData);
    }

    if (MediaQuery.sizeOf(context).width >= railBreakpoint) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onSelect,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (var i = 0; i < destinations.length; i++)
                  NavigationRailDestination(
                    icon: icon(i, selected: false),
                    selectedIcon: icon(i, selected: true),
                    label: Text(destinations[i].$3),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onSelect,
        destinations: [
          for (var i = 0; i < destinations.length; i++)
            NavigationDestination(
              icon: icon(i, selected: false),
              selectedIcon: icon(i, selected: true),
              label: destinations[i].$3,
            ),
        ],
      ),
    );
  }
}

/// Seul ce petit widget écoute le nombre d'articles : ajouter au panier ne
/// reconstruit pas toute la coque de navigation.
class _CartIcon extends ConsumerWidget {
  const _CartIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartItemCountProvider);
    return Semantics(
      label: context.l10n.cartBadgeSemantics(count),
      child: ExcludeSemantics(
        child: Badge(
          label: Text('$count'),
          isLabelVisible: count > 0,
          child: Icon(icon),
        ),
      ),
    );
  }
}
