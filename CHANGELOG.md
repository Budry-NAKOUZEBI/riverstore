# Changelog

Toutes les évolutions notables de RiverStore sont documentées ici.

Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) et le
projet respecte le [versionnage sémantique](https://semver.org/lang/fr/).

## [Unreleased]

## [2.0.0] - 2026-10-09

Version « production-ready » : l'application est testée de bout en bout,
mesurée, construite et publiée automatiquement.

### Added
- **Tests d'intégration** (`integration_test/`) exécutés sur l'application
  réelle :
  - parcours d'achat complet (recherche → détail → panier → paiement →
    confirmation → historique dans le profil) ;
  - persistance des favoris, de la langue et du thème après redémarrage ;
  - mesure des temps de frame pendant le défilement du catalogue
    (`watchPerformance`), exploitable en mode profile avec `flutter drive`.
- Génération automatique des captures d'écran du README
  (`integration_test/screenshots_test.dart`, désactivée par défaut).
- **CI/CD GitHub Actions** : format, `flutter analyze --fatal-infos`, tests
  avec couverture, tests d'intégration sous Xvfb, build de l'APK release et
  publication d'une release GitHub à chaque tag `v*`.
- Dependabot (dépendances pub et actions GitHub).
- README professionnel, captures d'écran, licence MIT.

### Changed
- Titre de la fenêtre Linux et locales iOS déclarées (`CFBundleLocalizations`).

### Fixed
- Android : ajout de la permission `INTERNET` dans le manifeste principal.
  Sans elle, les images produits ne se chargeaient pas dans l'APK release.

## [1.1.0] - 2026-10-09

Refonte de l'architecture, internationalisation, accessibilité et suite de
tests unitaires et de widgets.

### Added
- **Internationalisation FR/EN** (`flutter gen-l10n`, fichiers ARB) :
  interface, données produits bilingues, formats monétaires et dates selon
  la langue (`59,90 €` / `€59.90`). La langue de l'appareil est suivie par
  défaut et peut être forcée dans les paramètres.
- **Accessibilité** : libellés sémantiques et tooltips sur tous les éléments
  interactifs, carte produit annoncée comme un seul bouton descriptif,
  quantité annoncée en région live, action d'accessibilité « Retirer du
  panier », en-têtes sémantiques. Les recommandations Flutter (zones
  tactiles, libellés, contraste) sont vérifiées par des tests sur chaque
  écran.
- **Tunnel de commande** : écran de livraison (formulaire validé,
  pré-rempli depuis le profil, autofill), paiement simulé et écran de
  confirmation ; historique des commandes de la session dans le profil.
- **Écran Paramètres** : langue (appareil / français / anglais) et thème
  (auto / clair / sombre), persistés.
- Règles métier : livraison offerte dès 50 €, quantités plafonnées au
  stock, produits en rupture affichés et non commandables.
- Recherche insensible à la casse et aux accents, sur toutes les
  traductions du nom, avec debounce de 300 ms.
- Annulation de la suppression d'un article du panier (snackbar « Annuler »),
  confirmation avant de vider le panier, raccourci « Voir le panier ».
- Navigation adaptative : barre du bas sur mobile, rail latéral à partir
  de 840 dp.
- **74 tests automatisés** : 45 tests unitaires (logique métier, providers,
  repositories, intégrité des données et des traductions) et 29 tests de
  widgets.

### Changed
- Migration vers **Riverpod 3** (`Notifier` / `AsyncNotifier`) et
  **flutter_hooks** (`hooks_riverpod`) : contrôleurs de texte, animations et
  debounce sans `StatefulWidget`.
- Navigation déclarative avec **go_router** (`StatefulShellRoute` : chaque
  onglet garde sa pile) et gestion des routes inconnues.
- Montants manipulés en **centimes** (`int`) pour supprimer les erreurs
  d'arrondi des `double`.
- Format du catalogue JSON : textes `{fr, en}`, catégories sous forme de
  clés, miniatures distinctes des images pleine taille.
- Rebuilds ciblés : `select()` et providers dérivés (badge du panier,
  ligne de panier, bouton favori) pour que seul le widget concerné se
  reconstruise.
- Images décodées à leur taille d'affichage (`cacheWidth`), miniatures
  400 px dans les grilles, apparition en fondu.
- Règles d'analyse statique renforcées (`strict-casts`, `strict-raw-types`
  et lints supplémentaires).

### Removed
- `StateNotifier` / `StateProvider` (API héritée de Riverpod 2).

## [1.0.0] - 2026-08-28

Première version de RiverStore (jalon « State management avec Riverpod »).

### Added
- Catalogue de produits en grille, chargé depuis un JSON embarqué.
- Écran de détail produit.
- Panier : ajout, suppression, quantités, total en temps réel.
- Favoris persistés avec `shared_preferences`.
- Filtres par catégorie, recherche par nom et tri (prix, note, nom).
- Profil utilisateur simulé.
- Thèmes clair et sombre Material 3.

[Unreleased]: https://github.com/dp1370913-pixel/riverstore/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/dp1370913-pixel/riverstore/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/dp1370913-pixel/riverstore/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/dp1370913-pixel/riverstore/releases/tag/v1.0.0
