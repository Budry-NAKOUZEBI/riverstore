# RiverStore

Application e-commerce Flutter réalisée dans le cadre du projet de certification
« State management avec Riverpod ». Le catalogue, le panier, les favoris, le
profil et les filtres/tri sont entièrement pilotés par [Riverpod](https://riverpod.dev),
sans code généré (pas de `build_runner`), afin de rester lisible et facile à
auditer.

## Fonctionnalités

- **Catalogue de produits** : liste (grille) et écran de détail, chargés de
  façon asynchrone depuis un jeu de données JSON mocké.
- **Panier d'achat** : ajout, suppression, incrément/décrément de quantité,
  vidage, calcul du total en temps réel.
- **Favoris persistés** : sauvegardés localement via `shared_preferences`,
  conservés d'une session à l'autre.
- **Filtrage et tri** : recherche par nom, filtre par catégorie, tri par prix
  croissant/décroissant, meilleure note ou ordre alphabétique.
- **Profil utilisateur (mock)** : informations chargées de façon asynchrone,
  agrège aussi le nombre de favoris et d'articles au panier.
- **Bonus** : animation de confirmation sur le bouton « Ajouter au panier »
  (léger effet de zoom + icône de validation).

## Architecture

Le code est organisé en couches, séparant clairement les données, la logique
d'état et l'interface :

```
lib/
├── main.dart                     # Point d'entrée, initialise SharedPreferences
└── src/
    ├── app.dart                  # MaterialApp + thème
    ├── theme/
    │   └── app_theme.dart
    ├── data/
    │   ├── models/                # Product, CartItem/CartState, ProductFilter, UserProfile
    │   └── repositories/          # ProductRepository, UserRepository, FavoritesStorage
    ├── providers/                 # Toute la logique métier Riverpod (aucun widget ici)
    │   ├── core_providers.dart
    │   ├── product_providers.dart
    │   ├── favorites_providers.dart
    │   ├── cart_providers.dart
    │   ├── filter_providers.dart
    │   ├── user_providers.dart
    │   └── navigation_providers.dart
    └── ui/
        ├── navigation/main_scaffold.dart
        ├── screens/                # CatalogScreen, ProductDetailScreen, CartScreen, ...
        └── widgets/                # ProductCard, CartItemTile, ErrorView, LoadingView, ...
```

Règle suivie dans tout le projet : **les widgets ne contiennent aucune
logique métier**. Ils lisent l'état via `ref.watch`, déclenchent des actions
via `ref.read(provider.notifier).méthode()`, et se contentent d'afficher le
résultat (y compris les états de chargement/erreur via `AsyncValue.when`).

## Providers Riverpod utilisés

| Provider | Type | Rôle |
|---|---|---|
| `productRepositoryProvider` | `Provider<ProductRepository>` | Injection de dépendance, permet de substituer un faux repository dans les tests. |
| `productListProvider` | `FutureProvider<List<Product>>` | Charge le catalogue de façon asynchrone (`AsyncValue`). |
| `categoriesProvider` | `Provider<AsyncValue<List<String>>>` | Catégories dérivées du catalogue, pour les filtres. |
| `productByIdProvider` | `Provider.family<AsyncValue<Product>, String>` | Recherche un produit précis ; renvoie une erreur `ProductNotFoundException` si absent. |
| `filterProvider` | `StateNotifierProvider<FilterNotifier, ProductFilter>` | Requête de recherche, catégorie sélectionnée, option de tri. |
| `filteredProductsProvider` | `Provider<AsyncValue<List<Product>>>` | Combine `productListProvider` et `filterProvider` (provider dérivé). |
| `cartProvider` | `StateNotifierProvider<CartNotifier, CartState>` | Ajout/suppression/quantités du panier. |
| `cartItemCountProvider` / `cartTotalPriceProvider` | `Provider<int>` / `Provider<double>` | Valeurs calculées à partir du panier (badge, total). |
| `favoritesProvider` | `StateNotifierProvider<FavoritesNotifier, Set<String>>` | Favoris, persistés via `shared_preferences`. |
| `isFavoriteProvider` | `Provider.family<bool, String>` | Évite de reconstruire tout le panier de favoris pour un seul cœur. |
| `userProfileProvider` | `FutureProvider<UserProfile>` | Profil utilisateur mocké, chargé de façon asynchrone. |
| `selectedTabProvider` | `StateProvider<int>` | Onglet actif de la navigation principale. |
| `sharedPreferencesProvider` | `Provider<SharedPreferences>` | Instance injectée dans `ProviderScope` au démarrage (voir `main.dart`). |

Cela représente 9 providers distincts (bien au-delà du minimum de 5 demandé),
couvrant `Provider`, `Provider.family`, `StateProvider`, `FutureProvider` et
`StateNotifierProvider`.

## Gestion des états de chargement et d'erreur

Chaque donnée asynchrone (`productListProvider`, `productByIdProvider`,
`userProfileProvider`, `filteredProductsProvider`) est exposée sous forme
d'`AsyncValue` et consommée avec `.when(data:, loading:, error:)` dans les
écrans (`CatalogScreen`, `ProductDetailScreen`, `FavoritesScreen`,
`ProfileScreen`). Les erreurs affichent un message et un bouton « Réessayer »
qui invalide le provider concerné (`ref.invalidate(...)`) pour relancer le
chargement.

## Données mockées

Le catalogue provient d'un fichier JSON embarqué dans les assets
(`assets/data/products.json`, 14 produits répartis sur 5 catégories), chargé
par `MockProductRepository` avec un léger délai simulant un appel réseau.
Le profil utilisateur est généré par `MockUserRepository` (aucune
authentification réelle n'est requise pour ce projet).

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter analyze
flutter test
```

La suite de tests couvre :

- le parsing du modèle `Product` (`test/data/product_test.dart`) ;
- la logique du panier : ajout, incrément, suppression, total
  (`test/providers/cart_notifier_test.dart`) ;
- la persistance des favoris via `SharedPreferences`
  (`test/providers/favorites_notifier_test.dart`) ;
- la fonction pure de filtrage/tri (`test/providers/filter_logic_test.dart`) ;
- un test de widget vérifiant l'enchaînement chargement → données sur l'écran
  catalogue, avec un repository substitué via `ProviderScope.overrides`
  (`test/widget/catalog_screen_test.dart`).
