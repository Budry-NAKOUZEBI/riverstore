/// Erreurs de validation renvoyées sous forme de codes : la traduction en
/// message est faite par l'interface, ce qui garde ces règles testables
/// sans dépendre de la langue.
enum ValidationError { required, tooShort, invalidPhone }

abstract final class Validators {
  /// Mobile au Congo-Brazzaville : 9 chiffres commençant par 04, 05 ou 06
  /// (Airtel / MTN), avec ou sans indicatif +242 / 00242.
  static final _phoneRegExp = RegExp(r'^(?:\+242|00242)?0[456]\d{7}$');

  static ValidationError? required(String? value) =>
      (value == null || value.trim().isEmpty) ? ValidationError.required : null;

  static ValidationError? fullName(String? value) {
    final error = required(value);
    if (error != null) return error;
    return value!.trim().length < 2 ? ValidationError.tooShort : null;
  }

  static ValidationError? phone(String? value) {
    final error = required(value);
    if (error != null) return error;
    final compact = value!.replaceAll(RegExp(r'[\s.\-]'), '');
    return _phoneRegExp.hasMatch(compact) ? null : ValidationError.invalidPhone;
  }
}
