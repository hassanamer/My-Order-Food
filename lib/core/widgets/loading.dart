import 'package:flutter/material.dart';

class LoadingHandler {
  static Future<void> loadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}
