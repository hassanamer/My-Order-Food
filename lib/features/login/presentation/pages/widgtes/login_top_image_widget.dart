import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  const TopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/login.png',
      height: 205,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }
}
