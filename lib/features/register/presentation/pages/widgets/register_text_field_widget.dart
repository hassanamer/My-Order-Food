import 'package:flutter/material.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/theme_app.dart';

class RegisterTextFieldWidget extends StatelessWidget {
  const RegisterTextFieldWidget({
    required this.controller,
    required this.hintText,
    super.key,
    required this.icon,
    required this.validatorWord,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String validatorWord;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        fillColor: authTextFromFieldFillColor.withOpacity(.3),
        prefixIcon: Icon(
          icon,
          size: 24,
          color: ColorsManager.darkBlue.withOpacity(.8),
        ),
        suffixIcon: const Text(''),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorsManager.darkBlue.withOpacity(.2),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
      ),
      validator: (String? value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return 'Please enter the $validatorWord';
        }
      },
      controller: controller,
    );
  }
}
