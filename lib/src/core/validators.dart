/// Erreurs de validation renvoyées sous forme de codes : la traduction en
/// message est faite par l'interface, ce qui garde ces règles testables
/// sans dépendre de la langue.
enum ValidationError { required, tooShort, invalidEmail, invalidPostalCode }

abstract final class Validators {
  static final _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _postalCodeRegExp = RegExp(r'^\d{5}$');

  static ValidationError? required(String? value) =>
      (value == null || value.trim().isEmpty) ? ValidationError.required : null;

  static ValidationError? fullName(String? value) {
    final error = required(value);
    if (error != null) return error;
    return value!.trim().length < 2 ? ValidationError.tooShort : null;
  }

  static ValidationError? email(String? value) {
    final error = required(value);
    if (error != null) return error;
    return _emailRegExp.hasMatch(value!.trim())
        ? null
        : ValidationError.invalidEmail;
  }

  /// Code postal français : exactement 5 chiffres.
  static ValidationError? postalCode(String? value) {
    final error = required(value);
    if (error != null) return error;
    return _postalCodeRegExp.hasMatch(value!.trim())
        ? null
        : ValidationError.invalidPostalCode;
  }
}
