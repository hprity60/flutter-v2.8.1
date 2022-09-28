import 'package:flutter/material.dart';

class Utils {
  /// Checks if string is a valid username.
  static bool isUsername(String s) =>
      hasMatch(s, r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

  /// Checks if string is email.
  static bool isEmail(String s) => hasMatch(
      s, r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static bool isEmpty(dynamic value) {
    if (value is String) {
      return value.toString().trim().isEmpty;
    }
    if (value is Iterable || value is Map) {
      return value.isEmpty ?? false;
    }
    return false;
  }

  static void errorSnackBar(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 50,
          backgroundColor: Colors.black,
          content: Text(errorMsg,
              style: const TextStyle(
                color: Colors.red,
              )),
        ),
      );
  }

  static void successSnackBar(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 50,
          backgroundColor: Colors.blueGrey,
          content: Text(errorMsg,
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
      );
  }
}
