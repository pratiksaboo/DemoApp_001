class Validate {
    static Pattern versionPattern = "\\d.\\d.\\d";
    static RegExp versionExp = RegExp(versionPattern);
    static  RegExp _numeric = RegExp(r'^-?[0-9]+$');
  // RegEx pattern for validating email addresses.
  static Pattern emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  static RegExp emailRegEx = RegExp(emailPattern);

  // Validates an email address.
  static bool isEmail(String value) {
    if (emailRegEx.hasMatch(value.trim())) {
      return true;
    }
    return false;
  }
    static bool isVersion(String value) {
      if (versionExp.hasMatch(value.trim())) {
        return true;
      }
      return false;
    }

    static bool isNumeric(String str) {
      return _numeric.hasMatch(str);
    }
    /*
   * Returns an error message if email does not validate.
   */
  static String validateEmail(String value) {
    String email = value.trim();
    if (email.isEmpty) {
      return 'Email is required.';
    }
    if (! isEmail(email)) {
      return 'Valid email required.';
    }
    return null;
  }

  /*
   * Returns an error message if required field is empty.
   */
  static String requiredField(String value, String message) {
    if (value.trim().isEmpty) {
      return message;
    }
    return null;
  }
    static String validateVersion(String value) {
      String version = value.trim();
      if (version.isEmpty) {
        return 'Min App Version is required.';
      }
      if (!isVersion(version)) {
        return 'Valid version required.';
      }
      return null;
    }


}
