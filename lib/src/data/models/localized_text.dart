import 'package:flutter/foundation.dart';

/// Texte disponible en plusieurs langues (code ISO 639-1 → valeur).
@immutable
class LocalizedText {
  const LocalizedText(this.values);

  /// Accepte soit une simple chaîne (considérée comme française), soit un
  /// objet `{"fr": "...", "en": "..."}`.
  factory LocalizedText.fromJson(Object? json) {
    if (json is String) return LocalizedText({fallbackLanguage: json});
    final map = (json! as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value as String),
    );
    return LocalizedText(map);
  }

  static const fallbackLanguage = 'fr';

  final Map<String, String> values;

  /// Valeur dans la langue demandée, sinon en français, sinon la première
  /// traduction disponible.
  String resolve(String languageCode) =>
      values[languageCode] ??
      values[fallbackLanguage] ??
      (values.isEmpty ? '' : values.values.first);

  Iterable<String> get all => values.values;
}
