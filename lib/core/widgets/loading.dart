import 'package:flutter/material.dart';
import 'package:order/core/widgets/loading_widget.dart';

class LoadingHandler {
  static Future<void> loadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                child: const LoadingWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
