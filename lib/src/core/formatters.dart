import 'package:intl/intl.dart';

/// Formate un montant exprimé en centimes selon les conventions de la
/// langue active : `59,90 €` en français, `€59.90` en anglais.
String formatPrice(int cents, String locale) {
  final format = NumberFormat.currency(
    locale: locale,
    symbol: '€',
    decimalDigits: 2,
  );
  return format.format(cents / 100);
}
