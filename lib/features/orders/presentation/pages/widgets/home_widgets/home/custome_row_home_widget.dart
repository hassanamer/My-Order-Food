import 'package:flutter/material.dart';

class CustomRowHomePage extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Function? press;

  const CustomRowHomePage({
    required this.firstText,
    required this.secondText,
    super.key,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          firstText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            secondText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
