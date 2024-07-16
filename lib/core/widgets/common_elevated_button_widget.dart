import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CommonElevatedButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide.none,
          minimumSize: const Size(337, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyles.font18BlueSemiBold,
        ),
      ),
    );
  }
}
