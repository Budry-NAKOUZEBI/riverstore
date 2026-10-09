# Qualité : performance, accessibilité, i18n, tests, CI

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

- Français et anglais via [`lib/l10n/app_fr.arb`](../lib/l10n/app_fr.arb) (modèle) et [`app_en.arb`](../lib/l10n/app_en.arb)
  (132 clés, pluriels ICU, dates `yMMMMd`).
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
| Unitaires | 54 | `test/unit/` | Panier, favoris, filtres/tri, réglages, commande (mocktail), repositories, hiérarchie d'exceptions, stockage générique, modèles, validation du téléphone +242, formatage FCFA, intégrité des données et des traductions |
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
3. **Build Android** : APK et App Bundle (AAB) release, **signés avec la clé
   de release** (secrets GitHub, voir [RELEASE.md](RELEASE.md)), code Dart
   obfusqué, symboles de débogage archivés. Sur un tag `v*`, création d'une
   release GitHub avec l'APK et l'AAB ; la CI refuse de publier une version
   si la clé de signature est absente.

Dependabot surveille les dépendances pub et les actions GitHub.
