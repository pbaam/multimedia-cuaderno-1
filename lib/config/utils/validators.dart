import '../../l10n/app_localizations.dart';

/// Clase de utilidad para validaciones de formularios
class FormValidators {
  FormValidators._();

  /// Valida que el campo de nombre no esté vacío
  static String? validateName(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.mustEnterName;
    }
    return null;
  }

  /// Valida que el campo de email no esté vacío y tenga formato válido
  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.mustEnterEmail;
    }
    if (!value.contains('@')) {
      return l10n.invalidEmail;
    }
    return null;
  }

  /// Valida que el campo de contraseña no esté vacío
  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.mustEnterPassword;
    }
    return null;
  }

  /// Valida que el campo de confirmación de contraseña coincida con la contraseña
  static String? validateConfirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.mustRepeatPassword;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  /// Valida que el campo de edad no esté vacío y sea un número válido
  static String? validateAge(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.mustEnterAge;
    }
    if (int.tryParse(value) == null) {
      return l10n.invalidAge;
    }
    return null;
  }

  /// Valida que el campo de descripción no esté vacío
  static String? validateDescription(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.mustEnterDescription;
    }
    return null;
  }

  /// Valida que el campo de precio no esté vacío y sea un número válido
  static String? validatePrice(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.mustEnterPrice;
    }
    if (double.tryParse(value) == null) {
      return l10n.invalidPrice;
    }
    return null;
  }
}
