import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SnackBarMessage {
  void showSuccessSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

class FlutterToastMessageWidget {
  void showSuccessFlutterToast(
      {required String message, required BuildContext context}) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.green);
  }

  void showErrorFlutterToast(
      {required String message, required BuildContext context}) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.red);
  }
}
