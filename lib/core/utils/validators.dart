class Validators {
  const Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value)) {
      return 'invalid_email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }
    if (value.length < 6) {
      return 'password_short';
    }
    return null;
  }

  static String? notEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      return 'invalid_number';
    }
    return null;
  }
}
