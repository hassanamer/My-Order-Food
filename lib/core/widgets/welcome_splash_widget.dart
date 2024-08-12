import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';

class WelcomeSplashWidget extends StatefulWidget {
  const WelcomeSplashWidget({super.key});

  @override
  State<WelcomeSplashWidget> createState() => _WelcomeSplashWidgetState();
}

class _WelcomeSplashWidgetState extends State<WelcomeSplashWidget> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset('assets/images/splashhh.gif'),
    );
  }
}
