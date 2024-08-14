import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/theme_app.dart';

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget({
    required this.controllerEmail,
    super.key,
  });

  final TextEditingController controllerEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerEmail,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value == null) {
          return 'Please enter your mail address.';
        }
        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        final bool isValid = EmailValidator.validate(value);
        if (!isValid) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        fillColor: authTextFromFieldFillColor.withOpacity(.3),
        hintText: 'Example@gmail.com',
        hintStyle: TextStyle(
          color: ColorsManager.darkBlue.withOpacity(.2),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.email_outlined),
        suffixIcon: const Text(''),
        filled: true,
      ),
    );
  }
}
