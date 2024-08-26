import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

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
      style: TextStyles.font20BlueGradienteBoldForItemsList,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(.9),
        hintText: 'Example@gmail.com',
        hintStyle: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
          color: Colors.blue.shade900.withOpacity(.3),
        ),
        label: Text(
          'Email',
          style: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
            color: Colors.blue.shade900.withOpacity(.3),
          ),
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          size: 24,
          color: Colors.blue.shade900,
        ),
        suffixIcon: const Text(''),
        filled: true,
      ),
    );
  }
}
