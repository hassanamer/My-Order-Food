import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              child: Lottie.asset(
                'assets/animation/lotti_indecator.json',
                fit: BoxFit.fill,
              ),

              //    CircularProgressIndicator.adaptive(
              //     strokeWidth: 2.0,
              //     valueColor: AlwaysStoppedAnimation(
              //       themeManager.headerBackgroundColor,
              //     ),
              //     backgroundColor: Platform.isAndroid
              //         ? themeManager.backgroundColor
              //         : themeManager.headerBackgroundColor,
              //   ),
            ),
          ),
        ],
      ),
    );
  }
}
