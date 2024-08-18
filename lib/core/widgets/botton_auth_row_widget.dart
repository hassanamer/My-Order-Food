import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class BottomAuthRowWidget extends StatelessWidget {
  const BottomAuthRowWidget({
    required this.text,
    required this.value,
    required this.onTap,
    super.key,
  });

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
          style: TextStyles.font20WhiteBold,
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            value,
            style: TextStyles.font20DarkBlueBold,
          ),
        )
      ],
    );
  }
}
