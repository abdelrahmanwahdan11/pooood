class Validators {
  const Validators._();

  static String? notEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final sanitized = value?.replaceAll(',', '.');
    final parsed = double.tryParse(sanitized ?? '');
    if (parsed == null || parsed <= 0) {
      return 'invalid_number';
    }
    return null;
  }
}
