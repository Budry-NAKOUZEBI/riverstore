# RiverStore

[![CI](https://github.com/Budry-NAKOUZEBI/riverstore/actions/workflows/ci.yml/badge.svg)](https://github.com/Budry-NAKOUZEBI/riverstore/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter)
![Coverage](https://img.shields.io/badge/couverture-87%25-brightgreen)
![Tests](https://img.shields.io/badge/tests-84%20%2B%203%20int%C3%A9gration-brightgreen)
![i18n](https://img.shields.io/badge/i18n-FR%20%7C%20EN-blue)
![Devise](https://img.shields.io/badge/devise-FCFA%20(XAF)-0B4F44)
[![License: MIT](https://img.shields.io/badge/licence-MIT-lightgrey)](LICENSE)

**Boutique en ligne Flutter pour le Congo-Brazzaville** : prix en francs CFA,
livraison à Brazzaville, Pointe-Noire et Dolisie, paiement MTN Mobile Money,
Airtel Money ou espèces à la livraison. 8 écrans, FR/EN, accessibilité et
performances vérifiées par des tests, CI/CD avec APK signé.

**APK de démonstration** : [Releases](https://github.com/Budry-NAKOUZEBI/riverstore/releases)
· **Historique des versions** : [CHANGELOG.md](CHANGELOG.md)

<p>
  <img src="docs/screenshots/01_catalog.png" width="200" alt="Catalogue : bandeau Mbote sur motif wax et grille de produits en FCFA">
  <img src="docs/screenshots/02_product_detail.png" width="200" alt="Détail du costume trois-pièces La Sape">
  <img src="docs/screenshots/04_checkout.png" width="200" alt="Livraison et paiement Mobile Money">
  <img src="docs/screenshots/08_catalog_en_dark.png" width="200" alt="Catalogue en anglais, thème sombre">
</p>

## Cahier des charges : où trouver chaque exigence

| Exigence | Réalisation | Preuve |
|---|---|---|
| ≥ 5 écrans | **8** : catalogue, détail, favoris, panier, livraison & paiement, confirmation, profil, paramètres | [`lib/src/ui/screens/`](lib/src/ui/screens) |
| ≥ 10 tests unitaires | **54** (logique métier, providers, repositories, exceptions, stockage générique) | [`test/unit/`](test/unit) |
| ≥ 5 tests de widgets | **30** (dont accessibilité sur 7 écrans) | [`test/widget/`](test/widget) |
| ≥ 2 tests d'intégration | **3** : parcours d'achat complet, persistance après redémarrage, performance | [`integration_test/`](integration_test) |
| Performance : 60 fps, images optimisées et lazy-loadées, pas de rebuilds inutiles | Build moyen ≈ 2 ms/frame (mode profile), grilles paresseuses, images décodées à la taille affichée, `select()` + `flutter_hooks` + `const` | [Qualité › Performance](docs/QUALITE.md#performance) |
| Accessibilité (semantic labels) | Libellés sur tous les éléments interactifs, guidelines Flutter testées | [`accessibility_test.dart`](test/widget/accessibility_test.dart) |
| Internationalisation FR + EN | 132 clés, données produits bilingues, formats FCFA et dates localisés | [`app_fr.arb`](lib/l10n/app_fr.arb) · [`app_en.arb`](lib/l10n/app_en.arb) |
| CI/CD GitHub Actions (lint + tests) | Format, `flutter analyze --fatal-infos`, tests + couverture, intégration, APK/AAB signés | [`ci.yml`](.github/workflows/ci.yml) |
| `flutter analyze` sans warning | 0 problème, règles renforcées (`strict-casts`, `strict-raw-types`…) | [`analysis_options.yaml`](analysis_options.yaml) |
| README, captures, badges CI | Ce fichier, [8 captures](docs/screenshots) générées par test | — |
| CHANGELOG ≥ 3 versions | **5 versions** : 1.0.0 → 2.2.0 | [`CHANGELOG.md`](CHANGELOG.md) |
| POO | Classes abstraites, héritage, mixin, génériques, exceptions `sealed` | [Architecture › POO](docs/ARCHITECTURE.md#programmation-orientée-objet) |
| APK de démonstration | APK et AAB **signés avec une clé de release**, publiés sur chaque tag | [Releases](https://github.com/Budry-NAKOUZEBI/riverstore/releases) · [RELEASE.md](docs/RELEASE.md) |

## Démarrage rapide

Prérequis : Flutter 3.47 (Dart 3.13) ; pour Android, un JDK 17+.

```bash
git clone https://github.com/Budry-NAKOUZEBI/riverstore.git && cd riverstore
flutter pub get                     # génère aussi les traductions
flutter run                         # appareil ou émulateur
flutter test                        # 84 tests unitaires et de widgets
flutter test integration_test/purchase_flow_test.dart -d <appareil>
```

## Architecture en bref

```
lib/src/
├── core/          # Pur Dart : formatage FCFA, validation +242, recherche, exceptions
├── data/          # Modèles immuables + repositories (abstraits / implémentations)
├── providers/     # Logique métier Riverpod 3 (aucun widget)
├── router/        # go_router, une pile de navigation par onglet
└── ui/            # Écrans, widgets, thème « fleuve et latérite »
```

`Repository` → `Provider` / `Notifier` → providers dérivés (`select`,
`family`) → widgets. Détails et choix techniques :
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Documentation

| Document | Contenu |
|---|---|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Couches, flux de données, concepts POO, choix techniques |
| [QUALITE.md](docs/QUALITE.md) | Mesures de performance, accessibilité, i18n, détail des tests, CI/CD |
| [DESIGN.md](docs/DESIGN.md) | Identité visuelle : palette, typographies, motif wax |
| [RELEASE.md](docs/RELEASE.md) | Signature Android et publication d'une version |
| [CHANGELOG.md](CHANGELOG.md) | Historique des versions |

## Limites connues

- Backend simulé : catalogue JSON local, profil et commandes mockés ;
  paiements Mobile Money **simulés** (aucun appel aux API des opérateurs).
- Livraison limitée à trois villes, tarif unique ; panier non persisté
  entre les sessions.
- Photos d'illustration chargées depuis Pexels (connexion requise) : les
  personnes photographiées ne sont ni des clients ni des vendeurs.
- Linux avec un GNOME récent : lancer avec `GDK_BACKEND=x11` (bug GTK 3).

## Crédits et licence

Photos : [Pexels](https://www.pexels.com) (licence Pexels). Polices :
Bricolage Grotesque et Plus Jakarta Sans (SIL OFL 1.1, voir
`assets/fonts/`). Code sous licence [MIT](LICENSE).
