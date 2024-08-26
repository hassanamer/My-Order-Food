import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              child: Lottie.asset(
                'assets/animation/lotti_indecator.json',
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                fit: BoxFit.contain,
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
