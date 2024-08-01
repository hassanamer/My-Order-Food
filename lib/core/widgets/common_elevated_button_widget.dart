import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/core/theming/styles.dart';

class CommonElevatedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double fontSize;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double width;
  final double height;

  CommonElevatedButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.fontSize = 18.0,
    this.borderRadius = 15.0,
    this.elevation = 5.0,
    this.padding = const EdgeInsets.all(15),
    this.width = 381,
    this.height = 55,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(elevation),
          shadowColor: WidgetStateProperty.all<Color>(
            Colors.grey.withOpacity(0.5),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(fontSize: fontSize),
          ),
        ),
        child: Text(
          text,
          style: TextStyles.font20WhiteBold,
        ),
      ),
    );
  }
}
