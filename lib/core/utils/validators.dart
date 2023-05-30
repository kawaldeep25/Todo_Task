class Validator {
  Validator._();

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // RegEx pattern for validating email addresses.
  // static Pattern emailPattern =
  //     r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  // static RegExp emailRegEx = RegExp(emailPattern);

  static bool isValidEmail(String email) {
    const _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
  }

  static bool isValidUserName(String userName) {
    return userName.length >= 3;
  }

  // // Validates an email address.
  // static bool isMobile(String value) {
  //   if (mobileRegEx.hasMatch(value.trim())) {
  //     return true;
  //   }
  //   return false;
  // }

  // Validates an email address.
  // static bool isEmail(String value) {
  //   if (emailRegEx.hasMatch(value.trim())) {
  //     return true;
  //   }
  //   return false;
  // }
  //
  // /*
  //  * Returns an error message if email does not validate.
  //  */
  // static String? validateEmail(String value) {
  //   String email = value.trim();
  //   if (email.isEmpty) {
  //     return 'Email-Id cannot be empty';
  //   }
  //   if (!isEmail(email)) {
  //     return 'Email-Id is not valid';
  //   }
  //   return null;
  // }
}
