import 'package:flutter/material.dart';
import 'package:order/core/theming/theme_app.dart';

class RegisterTextFieldWidget extends StatelessWidget {
  const RegisterTextFieldWidget({
    required this.controller,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        fillColor: authTextFromFieldFillColor.withOpacity(.3),
        prefixIcon: const Icon(
          Icons.person_outline,
          size: 24,
          color: authTextFromFieldHintTextColor,
        ),
        suffixIcon: const Text(''),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: authTextFromFieldHintTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
      ),
      validator: (String? value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return 'please fill the form';
        }
      },
      controller: controller,
    );
  }
}
