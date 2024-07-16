import 'package:flutter/material.dart';

class UnderlineTextWidget extends StatelessWidget {
  const UnderlineTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.amber,
        width: 1.0, // Underline thickness
      ))),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
