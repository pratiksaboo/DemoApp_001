import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';


class Utility {
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';


  static String getRandomString(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += _chars[rnd.nextInt(_chars.length)];
    }
    return result;
  }

//  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  static String dateConverter(String date) {
    // Input date Format
    final format = DateFormat.yMMMMd("en_US");
    DateTime gettingDate = format.parse(date);
    final DateFormat formatter = DateFormat("yyyy-MM-dd", "en_US");
    // Output Date Format
    final String formatted = formatter.format(gettingDate);
    return formatted;
  }

  static String now() {
    DateTime now = DateTime.now();
    String formattedDate= DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return formattedDate;
  }

  static Future<String> getCurrentUID() async {
    // final auth.User user = auth.FirebaseAuth.instance.currentUser;
    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    final String uid = user.uid;
    return uid;
  }

  static String getFileExtension(uri) {
    return uri.path
        .split('.')
        .last;
  }

  static String getErrorMessage(String exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage =
        "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

  // Future<String> getRegionInfo(uri) async {
  //   PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(uri);
  //   String result = "+"+number.dialCode;
  //   return result;
  // }

