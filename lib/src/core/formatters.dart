import 'package:intl/intl.dart';

/// Un `NumberFormat` par locale : sa construction (analyse du motif,
/// symboles de la locale) est coûteuse et `formatPrice` est appelé pour
/// chaque carte produit.
final _formats = <String, NumberFormat>{};

/// Formate un montant en francs CFA (XAF). Le franc CFA n'utilise pas de
/// subdivision : les montants sont des entiers.
///
/// `25 000 FCFA` en français, `25,000 FCFA` en anglais. L'espace fine
/// insécable (U+202F) d'`intl` est remplacée par une espace insécable
/// classique, présente dans les polices de l'application.
String formatPrice(int amount, String locale) {
  final format = _formats.putIfAbsent(
    locale,
    () => NumberFormat.decimalPattern(locale),
  );
  final digits = format.format(amount).replaceAll(' ', ' ');
  return '$digits FCFA';
}
