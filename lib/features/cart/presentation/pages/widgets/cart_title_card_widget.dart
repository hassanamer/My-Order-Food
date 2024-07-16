import 'package:flutter/material.dart';

class CartTitleCardWidget extends StatelessWidget {
  const CartTitleCardWidget({
    Key? key,
    required this.title,
    this.textStyle = const TextStyle(
      color: Colors.blue,
      fontSize: 25,
    ),
  }) : super(key: key);

  final String title;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      alignment: Alignment.centerLeft,
      child: Text(title, textAlign: TextAlign.left, style: textStyle),
    );
  }
}
