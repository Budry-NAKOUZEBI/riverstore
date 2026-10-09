# Architecture

```
lib/
├── main.dart                  # Point d'entrée : licences des polices, SharedPreferences, buildApp()
├── l10n/                      # ARB FR/EN + classes générées (gen-l10n)
└── src/
    ├── bootstrap.dart         # ProviderScope + injection des dépendances
    ├── app.dart               # MaterialApp.router (locale, thème, routeur)
    ├── core/                  # Pur Dart : formatage FCFA, validation (téléphone +242), recherche
    ├── data/
    │   ├── models/            # Modèles immuables (Product, CartState, Order, PaymentMethod…)
    │   └── repositories/      # Interfaces + implémentations (assets, mocks, prefs)
    ├── providers/             # Logique métier Riverpod (aucun widget)
    ├── router/                # go_router : routes, StatefulShellRoute
    └── ui/
        ├── screens/           # 8 écrans
        ├── shell/             # Barre de navigation / rail adaptatif
        ├── widgets/           # Composants (carte produit, motif wax, logo, prix…)
        └── theme/             # Palette, typographie, thèmes des composants
```

**Flux de données** : `Repository` → `Provider` / `Notifier` → providers
dérivés (`select`, `family`) → widgets. Les widgets ne contiennent pas de
logique métier ; tout ce qui peut l'être est une fonction pure testée
isolément (`applyFilterAndSort`, `OrderPricing`, `Validators`,
`formatPrice`, `normalizeForSearch`).

## Programmation orientée objet

| Concept | Où | Rôle |
|---|---|---|
| **Classes abstraites** (contrats) | [`ProductRepository`](../lib/src/data/repositories/product_repository.dart), [`UserRepository`](../lib/src/data/repositories/user_repository.dart), [`OrderRepository`](../lib/src/data/repositories/order_repository.dart) | L'interface et les providers ne dépendent que de ces abstractions ; les tests leur substituent des fakes ou des mocks (`mocktail`). |
| **Héritage + polymorphisme** | `AssetProductRepository extends ProductRepository`, `MockOrderRepository extends OrderRepository`… | Une implémentation « API REST » se brancherait par simple override de provider. |
| **Mixin** | [`SimulatedLatency`](../lib/src/data/repositories/simulated_latency.dart) | Latence simulée partagée par les repositories de démonstration, injectable (`Duration.zero` en test). |
| **Généricité** | [`KeyValueStore<T>`](../lib/src/data/repositories/key_value_store.dart) étendue par `FavoritesStorage` (`Set<String>`) et `SettingsStorage` (`AppSettings`) ; `_byName<E extends Enum>` ; `Notifier<T>` / `AsyncNotifier<T>` | Lecture tolérante aux données corrompues écrite une seule fois pour tous les stockages. |
| **Exceptions métier** | [`sealed class AppException implements Exception`](../lib/src/core/errors.dart) → `CatalogLoadException`, `ProductNotFoundException`, `EmptyCartException`, `OrderFailedException` | Les erreurs techniques (JSON invalide, asset manquant) sont encapsulées avec leur cause ; l'UI les traduit via un `switch` **exhaustif** ([`userMessageFor`](../lib/src/ui/l10n_extensions.dart)). |
| **Encapsulation et immuabilité** | Modèles `@immutable` (`Product`, `CartState`, `Order`…), champs `final`, constructeurs `const`, horloge et latence injectées | État prévisible, comparaison par valeur (`==` / `hashCode`), tests déterministes. |
| **Énumérations enrichies** | `AppLanguage` (porte sa `Locale`), `PaymentMethod`, `ProductCategory` | Pas de chaînes magiques ; `switch` exhaustifs pour les libellés. |

Tests associés : [`test/unit/oop_test.dart`](../test/unit/oop_test.dart).

## Choix techniques

| Sujet | Choix | Raison |
|---|---|---|
| État | Riverpod 3 (`Notifier`, `AsyncNotifier`) | Injection testable (`overrideWithValue`), providers dérivés, pas de code généré |
| Widgets à état local | `flutter_hooks` (`HookConsumerWidget`) | Contrôleurs, animations et debounce libérés automatiquement, sans `StatefulWidget` |
| Navigation | go_router + `StatefulShellRoute` | Chaque onglet conserve sa pile, routes testables, page 404 |
| Montants | `int` en francs CFA | Le FCFA n'a pas de subdivision : aucun calcul en `double` |
| Persistance | `shared_preferences` | Favoris et réglages ; lecture tolérante aux valeurs corrompues |
| i18n | `flutter_localizations` + `intl` (gen-l10n) | Pluriels ICU, dates et nombres localisés |
| Données | JSON embarqué + repositories mockés | Démo et tests déterministes ; remplaçable par une API sans toucher l'UI |
