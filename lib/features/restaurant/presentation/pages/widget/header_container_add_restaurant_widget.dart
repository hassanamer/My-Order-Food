import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class UnderlineTextWidget extends StatelessWidget {
  const UnderlineTextWidget({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 0,
      ),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.white,
        width: 1.0, // Underline thickness
      ))),
      child: Text(
        text,
        style: TextStyles.font24BlueBold,
      ),
    );
  }
}
