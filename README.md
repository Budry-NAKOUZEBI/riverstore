# RiverStore

[![CI](https://github.com/dp1370913-pixel/riverstore/actions/workflows/ci.yml/badge.svg)](https://github.com/dp1370913-pixel/riverstore/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)
![Coverage](https://img.shields.io/badge/couverture-87%25-brightgreen)
![Tests](https://img.shields.io/badge/tests-77%20%2B%203%20int%C3%A9gration-brightgreen)
![i18n](https://img.shields.io/badge/i18n-FR%20%7C%20EN-blue)
![Devise](https://img.shields.io/badge/devise-FCFA%20(XAF)-0B4F44)
[![License: MIT](https://img.shields.io/badge/licence-MIT-lightgrey)](LICENSE)

**RiverStore** est une boutique en ligne pensée pour le **Congo-Brazzaville** :
prix en francs CFA, livraison à domicile à Brazzaville, Pointe-Noire et
Dolisie, adresses par quartier et point de repère, paiement **MTN Mobile
Money**, **Airtel Money** ou en espèces à la livraison. Le catalogue mêle
pagnes wax, costumes de sapeur, artisanat de Poto-Poto et équipements utiles
pendant les délestages (kit solaire, batterie externe, ventilateur
rechargeable).

Le projet est parti du jalon « State management avec Riverpod », puis a été
rendu **production-ready** : architecture en couches, 8 écrans, identité
visuelle propre, internationalisation FR/EN, accessibilité vérifiée par des
tests, performances mesurées, CI/CD et APK publié automatiquement.

> **APK de démonstration** : téléchargeable dans les
> [Releases](https://github.com/dp1370913-pixel/riverstore/releases) (publié
> par la CI à chaque tag `v*`) ou dans les artefacts du dernier run CI.

## Sommaire

- [Captures d'écran](#captures-décran)
- [Fonctionnalités](#fonctionnalités)
- [Identité visuelle](#identité-visuelle)
- [Architecture](#architecture)
- [Performance](#performance)
- [Accessibilité](#accessibilité)
- [Internationalisation](#internationalisation)
- [Tests](#tests)
- [CI/CD](#cicd)
- [Installation](#installation)
- [Limites connues](#limites-connues)
- [Crédits](#crédits)

## Captures d'écran

| Catalogue | Détail | Panier | Livraison & paiement |
|:---:|:---:|:---:|:---:|
| <img src="docs/screenshots/01_catalog.png" width="190" alt="Catalogue : bandeau Mbote sur motif wax, recherche, catégories et grille de produits en FCFA"> | <img src="docs/screenshots/02_product_detail.png" width="190" alt="Détail du costume trois-pièces La Sape à 120 000 FCFA"> | <img src="docs/screenshots/03_cart.png" width="190" alt="Panier avec livraison offerte au-delà de 50 000 FCFA"> | <img src="docs/screenshots/04_checkout.png" width="190" alt="Formulaire de livraison avec téléphone +242 et choix MTN Mobile Money, Airtel Money ou espèces"> |

| Favoris | Profil | Paramètres (EN, sombre) | Catalogue (EN, sombre) |
|:---:|:---:|:---:|:---:|
| <img src="docs/screenshots/05_favorites.png" width="190" alt="Favoris"> | <img src="docs/screenshots/06_profile.png" width="190" alt="Profil de Grâce Mabiala à Brazzaville"> | <img src="docs/screenshots/07_settings_en_dark.png" width="190" alt="Paramètres en anglais, thème sombre"> | <img src="docs/screenshots/08_catalog_en_dark.png" width="190" alt="Catalogue en anglais, thème sombre"> |

Les captures sont générées par un test (`integration_test/screenshots_test.dart`),
ce qui les garde à jour avec le code (voir [Installation](#installation)).

## Fonctionnalités

| Écran | Contenu |
|---|---|
| **Catalogue** | Bandeau d'accueil « Mbote ! », grille responsive paresseuse, recherche (debounce, insensible aux accents, FR + EN), filtres par catégorie, tri, pull-to-refresh, états chargement / vide / erreur |
| **Détail produit** | Grande photo repliable, catégorie, stock, note, description, barre d'achat avec le prix ; quantité plafonnée au stock |
| **Favoris** | Produits favoris persistés entre les sessions |
| **Panier** | Quantités, suppression par glissement avec « Annuler », vidage confirmé, progression vers la livraison offerte |
| **Livraison & paiement** | Nom, téléphone **+242** (MTN 06, Airtel 04/05) validé, ville desservie, quartier, adresse **et point de repère** ; MTN Mobile Money, Airtel Money ou espèces à la livraison (paiement simulé) |
| **Confirmation** | Numéro de commande, adresse, moyen de paiement, récapitulatif |
| **Profil** | Initiales sur motif wax, téléphone et ville, statistiques, commandes de la session |
| **Paramètres** | Langue (appareil / FR / EN) et thème (auto / clair / sombre), persistés ; licences (dont celles des polices) |

**Règles métier** : montants entiers en FCFA, livraison à domicile
2 000 FCFA, offerte dès 50 000 FCFA, quantités plafonnées au stock, produits
en rupture visibles mais non commandables.

Sur grand écran (≥ 840 dp), la barre de navigation du bas est remplacée par
un rail latéral.

## Identité visuelle

L'interface s'éloigne du Material « par défaut » tout en restant sobre :

| Élément | Choix |
|---|---|
| Palette « fleuve et latérite » | Vert profond du fleuve Congo `#0B4F44`, terracotta de la latérite `#B4461E` pour les actions d'achat, or `#E3A72F` pour les mises en avant, fond crème chaud. Schémas clair **et** sombre définis couleur par couleur. |
| Typographie | **Bricolage Grotesque** (titres, prix) et **Plus Jakarta Sans** (texte), embarquées dans l'app (licence OFL, aucun téléchargement au lancement). |
| Motif wax | Anneaux concentriques, graines et points sur une trame décalée, **dessinés en vectoriel** (`CustomPainter`), utilisés dans le bandeau d'accueil, le profil et la confirmation. |
| Composants | Logo « vagues du fleuve », cartes arrondies à double bordure, prix avec montant en gras et devise réduite, pastilles de note sur les photos, sections de formulaire en cartes. |

Le contraste du texte est vérifié automatiquement sur chaque écran (voir
[Accessibilité](#accessibilité)).

## Architecture

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

### Choix techniques

| Sujet | Choix | Raison |
|---|---|---|
| État | Riverpod 3 (`Notifier`, `AsyncNotifier`) | Injection testable (`overrideWithValue`), providers dérivés, pas de code généré |
| Widgets à état local | `flutter_hooks` (`HookConsumerWidget`) | Contrôleurs, animations et debounce libérés automatiquement, sans `StatefulWidget` |
| Navigation | go_router + `StatefulShellRoute` | Chaque onglet conserve sa pile, routes testables, page 404 |
| Montants | `int` en francs CFA | Le FCFA n'a pas de subdivision : aucun calcul en `double` |
| Persistance | `shared_preferences` | Favoris et réglages ; lecture tolérante aux valeurs corrompues |
| i18n | `flutter_localizations` + `intl` (gen-l10n) | Pluriels ICU, dates et nombres localisés |
| Données | JSON embarqué + repositories mockés | Démo et tests déterministes ; remplaçable par une API sans toucher l'UI |

## Performance

Mesures faites avec `integration_test/performance_test.dart` en **mode
profile** (`flutter drive --profile`) : 6 flings sur le catalogue, environ
110 frames, sur un PC portable d'entrée de gamme (processeur Intel Gemini
Lake). Le test mesure deux situations : sans lecteur d'écran, et avec un
lecteur d'écran actif (l'arbre d'accessibilité est alors recalculé à chaque
frame).

| Métrique (thread UI, 3 exécutions) | Sans lecteur d'écran | Avec lecteur d'écran | Budget 60 fps |
|---|---|---|---|
| Temps de build moyen | **1,7 à 2,2 ms** | 1,6 à 1,8 ms | 16,7 ms |
| 90ᵉ percentile | 2,8 à 4,6 ms | 2,7 à 3,3 ms | 16,7 ms |
| Frames hors budget | 2 / ~110 | **0** / ~110 | — |

Les 2 frames hors budget surviennent uniquement lors du **premier**
défilement après le lancement, quand les caches sont froids (polices, images,
code exécuté pour la première fois). Le second passage, pourtant plus
coûteux puisqu'il calcule l'arbre d'accessibilité, n'en produit aucune.

Ce qui garantit ces chiffres :

- **Pas de rebuild inutile** : badge du panier, lignes du panier et boutons
  favoris écoutent chacun uniquement leur valeur (`select`, `family`). Un
  test vérifie qu'un changement de quantité ne notifie pas la liste du
  panier (`cart_notifier_test.dart`). Constructeurs `const` partout (lint
  `prefer_const_constructors`).
- **Cartes produit légères** : les boutons favori et panier des cartes sont
  des `RoundIconButton` (zone tactile de 48 dp, libellé d'accessibilité,
  effet d'encre) plutôt que des `IconButton` Material 3 avec tooltip. La
  mesure a montré que ces derniers représentaient le plus gros du coût de
  construction d'une carte.
- **Images optimisées** : miniatures 480 px recadrées côté serveur pour la
  grille, 900 px pour le détail, décodage à la taille réellement affichée
  (`cacheWidth`, arrondi par paliers de 100 px pour partager le cache), fond
  réservé et fondu (aucun saut de mise en page).
- **Lazy-loading** : `SliverGrid.builder` / `ListView.builder`, si bien que
  seules les cartes visibles (et leurs images) sont construites et
  téléchargées.
- **Travail évité** : recherche debouncée (300 ms), catalogue chargé une
  seule fois puis filtré en mémoire, `NumberFormat` mis en cache par locale,
  motif wax isolé dans un `RepaintBoundary`.

> Le temps de **raster** n'est pas significatif sur la machine de mesure
> (Linux, GPU intégré via XWayland) : une application Flutter vide de
> référence y affiche le même ordre de grandeur (~100 ms par frame). Pour
> une mesure GPU représentative, lancer le test de performance sur un
> appareil Android physique (commande dans [Tests](#tests)).

## Accessibilité

- Tous les éléments interactifs ont un **libellé localisé** lu par TalkBack
  et VoiceOver : favoris, ajout au panier avec le nom du produit, quantité
  +/−, tri, vider le panier, paramètres, moyens de paiement.
- La carte produit est annoncée comme **un seul bouton descriptif**
  (« Pagne wax hollandais 6 yards, 18 000 FCFA, noté 4.7 sur 5 ») ; ses
  boutons favori et panier restent des nœuds séparés. Le prix est toujours
  annoncé en entier, même quand il est affiché en deux tailles.
- Quantité annoncée en **région live**, état activé/désactivé sur le
  bouton favori, **action d'accessibilité** « Retirer du panier » (alternative
  au glissement), en-têtes sémantiques, photos produit décrites.
- `test/widget/accessibility_test.dart` vérifie sur **les 7 écrans
  principaux** les recommandations Flutter : zones tactiles ≥ 48 dp
  (Android) / 44 pt (iOS), éléments interactifs étiquetés, contraste du
  texte (y compris sur le motif wax, grâce au dégradé sous le texte).

## Internationalisation

- Français et anglais via `lib/l10n/app_fr.arb` (modèle) et `app_en.arb`
  (131 clés, pluriels ICU, dates `yMMMMd`).
- Les données produits sont bilingues (`{"fr": …, "en": …}`), avec repli
  sur le français.
- Montants en FCFA formatés selon la langue : `25 000 FCFA` / `25,000 FCFA`.
- Par défaut l'app suit la langue de l'appareil (une langue non supportée
  bascule en anglais), et l'utilisateur peut la forcer dans Paramètres.
- Un test vérifie que les deux fichiers ARB définissent exactement les
  mêmes clés, et un autre que chaque produit du catalogue est traduit.

## Tests

| Type | Nombre | Emplacement | Couvre |
|---|---|---|---|
| Unitaires | 47 | `test/unit/` | Panier, favoris, filtres/tri, réglages, commande (mocktail), repositories, modèles, validation du téléphone +242, formatage FCFA, intégrité des données et des traductions |
| Widgets | 30 | `test/widget/` | Carte produit, stepper, catalogue (chargement, bandeau, debounce, filtres, erreur/réessai), panier, checkout (validation, moyens de paiement), app complète (langue, badge, commande, 404), accessibilité × 7 écrans |
| Intégration | 3 | `integration_test/` | Parcours d'achat complet (paiement Airtel Money), persistance après redémarrage, performance du défilement (avec et sans lecteur d'écran) |

Couverture de lignes : **87 %**.

```bash
flutter test                         # unitaires + widgets
flutter test --coverage              # + coverage/lcov.info

# Intégration (un fichier à la fois : l'app Linux est mono-instance)
flutter test integration_test/purchase_flow_test.dart -d linux
flutter test integration_test/preferences_flow_test.dart -d linux
flutter test integration_test/performance_test.dart -d <android-device-id>

# Mesure de performance en mode profile
flutter drive --profile --driver=test_driver/integration_test.dart \
  --target=integration_test/performance_test.dart -d <device>
```

## CI/CD

`.github/workflows/ci.yml`, déclenché sur push, pull request et tag :

1. **Lint & tests** : `dart format` (échec si non formaté),
   `flutter analyze --fatal-infos --fatal-warnings`, `flutter test --coverage`
   (taux affiché dans le résumé du run).
2. **Tests d'intégration** : application Linux desktop sous Xvfb.
3. **Build Android** : APK release en artefact ; sur un tag `v*`, création
   d'une release GitHub avec l'APK attaché.

Dependabot surveille les dépendances pub et les actions GitHub.

## Installation

Prérequis : Flutter **3.47** (Dart 3.13). Pour Android : un JDK 17+ complet
(avec `javac`).

```bash
git clone https://github.com/dp1370913-pixel/riverstore.git
cd riverstore
flutter pub get          # génère aussi les traductions
flutter run              # appareil ou émulateur connecté
flutter build apk --release
```

Régénérer les captures d'écran :

```bash
flutter test integration_test/screenshots_test.dart -d linux \
  --dart-define=SCREENSHOT_DIR=$PWD/docs/screenshots
```

## Limites connues

- Backend simulé : catalogue en JSON local, profil et commandes mockés. Les
  paiements **MTN Mobile Money et Airtel Money sont simulés** (aucun appel
  aux API des opérateurs) ; les interfaces `ProductRepository`,
  `UserRepository` et `OrderRepository` permettent de brancher un vrai
  backend.
- Livraison limitée à trois villes (Brazzaville, Pointe-Noire, Dolisie) avec
  un tarif unique.
- Le panier et l'historique des commandes ne sont pas persistés entre les
  sessions (seuls les favoris et les réglages le sont).
- L'APK est signé avec la clé de debug : suffisant pour une démonstration,
  pas pour une publication sur le Play Store.
- Les photos sont chargées depuis le CDN de Pexels (connexion requise ; un
  pictogramme les remplace hors-ligne). Ce sont des photos d'illustration :
  les personnes photographiées ne sont pas des clients ni des vendeurs.
- Sous Linux avec un GNOME récent, lancer l'app avec `GDK_BACKEND=x11` pour
  contourner un bug GTK 3 (« Settings schema … does not contain a key named
  'antialiasing' »).

## Crédits

- Photos produits : [Pexels](https://www.pexels.com) (licence Pexels,
  utilisation libre sans attribution obligatoire).
- Polices : [Bricolage Grotesque](https://fonts.google.com/specimen/Bricolage+Grotesque)
  et [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans),
  licence SIL Open Font License 1.1 (textes dans `assets/fonts/`).

## Licence

Code sous licence [MIT](LICENSE).
