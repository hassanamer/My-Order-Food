import 'package:flutter/material.dart';
import 'package:order/core/theming/theme_app.dart';

class LoginTextFieldWidget extends StatelessWidget {
  const LoginTextFieldWidget({
    required this.controllerEmail,
    required this.prefixIcon,
    required this.hintText,
    required this.obscureText,
    super.key,
    this.suffixIcon,
    this.onChanged,
  });

  final TextEditingController controllerEmail;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool obscureText;
  final VoidCallback? onChanged;

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
      validator: (String? value) {
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
