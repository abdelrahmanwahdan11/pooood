class Validators {
  Validators._();

  static String? requiredField(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? minLength(String? value, int min,
      {String message = 'Too short'}) {
    if (value == null || value.trim().length < min) {
      return message;
    }
    return null;
  }

  static String? year(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final year = int.tryParse(value);
    final currentYear = DateTime.now().year;
    if (year == null || year < 1980 || year > currentYear + 1) {
      return 'Invalid year';
    }
    return null;
  }
}
