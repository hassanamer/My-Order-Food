import 'package:flutter/material.dart';
import 'package:order/core/theme_app.dart';

class BottomAuthRowWidget extends StatelessWidget {
  const BottomAuthRowWidget({
    Key? key,
    required this.text,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: const TextStyle(color: primaryColor),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            value,
            style: const TextStyle(color: headline1Color),
          ),
        )
      ],
    );
  }
}
