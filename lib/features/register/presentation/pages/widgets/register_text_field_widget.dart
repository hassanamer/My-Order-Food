import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

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
      style: TextStyles.font20BlueGradienteBoldForItemsList,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(.9),
        prefixIcon: Icon(
          icon,
          size: 24,
          color: Colors.blue.shade900,
        ),
        suffixIcon: const Text(''),
        hintText: hintText,
        hintStyle: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
          color: Colors.blue.shade900.withOpacity(.3),
        ),
        label: Text(
          '$hintText',
          style: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
            color: Colors.blue.shade900.withOpacity(.3),
          ),
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
