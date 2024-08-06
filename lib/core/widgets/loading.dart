import 'package:flutter/material.dart';

import 'loading_widget.dart';

class LoadingHandler {
  static Future<void> loadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(
              child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: Colors.transparent, child: LoadingWidget()),
          )),
        );
      },
    );
  }
}
