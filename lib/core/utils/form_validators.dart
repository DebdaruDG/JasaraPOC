class FormValidators {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  static String? validateCharLimit(String? value, int max) {
    if (value != null && value.length > max) {
      return 'Max $max characters allowed.';
    }
    return null;
  }
}
