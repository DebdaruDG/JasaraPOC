import 'package:flutter/material.dart';

class JasaraToast {
  static Future<void> success(BuildContext context, String message) {
    return _showToast(context, message, backgroundColor: Colors.green);
  }

  static Future<void> error(BuildContext context, String message) {
    return _showToast(context, message, backgroundColor: Colors.red);
  }

  static Future<void> _showToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.clearSnackBars(); // Clear existing SnackBars
    final snackBar = scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
    await snackBar.closed;
  }
}
