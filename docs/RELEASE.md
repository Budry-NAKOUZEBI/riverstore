# Publier une version

## Signature Android

Les builds release sont signés avec une **clé de release** (jamais avec la
clé de debug lorsqu'une version est publiée).

| Où | Comment la clé est fournie |
|---|---|
| Machine locale | `android/key.properties` + `android/app/upload-keystore.jks`, tous deux ignorés par git (`android/.gitignore`). Sans eux, `flutter build apk --release` signe en debug pour le développement. |
| GitHub Actions | Quatre secrets du dépôt, convertis en `key.properties` au moment du build (étape *Configure release signing* de [`ci.yml`](../.github/workflows/ci.yml)). |

Secrets à créer dans **Settings → Secrets and variables → Actions** :

| Secret | Valeur |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 android/app/upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | `storePassword` de `android/key.properties` |
| `ANDROID_KEY_ALIAS` | `keyAlias` de `android/key.properties` |
| `ANDROID_KEY_PASSWORD` | `keyPassword` de `android/key.properties` |

Sur un tag `v*`, la CI **échoue** si ces secrets manquent : aucune release
ne peut être publiée avec la clé de debug.

> Sauvegardez `upload-keystore.jks` et ses mots de passe hors du dépôt
> (gestionnaire de mots de passe) : sans cette clé, il est impossible de
> publier une mise à jour de l'application sur le Play Store.

## Créer une version

1. Mettre à jour `version:` dans `pubspec.yaml`, `appVersion` dans
   `lib/src/core/app_info.dart` et le [`CHANGELOG.md`](../CHANGELOG.md).
2. Committer, puis créer et pousser **un seul** tag (GitHub ne déclenche
   aucun workflow si plus de trois tags sont poussés en une fois) :

   ```bash
   git tag -a v2.2.0 -m "RiverStore 2.2.0"
   git push origin main v2.2.0
   ```
3. La CI publie la release avec `riverstore-v2.2.0.apk` (installation
   directe) et `riverstore-v2.2.0.aab` (Play Store). Les symboles de
   débogage de l'obfuscation sont dans l'artefact `debug-symbols`.
