import 'package:flutter/material.dart';
import 'package:order/core/theme_app.dart';

class LoginTextFieldWidget extends StatelessWidget {
  const LoginTextFieldWidget({
    Key? key,
    required this.controllerEmail,
    required this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  final TextEditingController controllerEmail;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        filled: true,
        fillColor: authTextFromFieldHintTextColor.withOpacity(.3),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return 'Please fill the form';
        }
      },
      controller: controllerEmail,
    );
  }
}
