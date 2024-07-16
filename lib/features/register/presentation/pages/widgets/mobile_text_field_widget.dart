import 'package:flutter/material.dart';

import '../../../../../core/theme_app.dart';

class MobileTextFieldWidget extends StatelessWidget {
  const MobileTextFieldWidget({
    Key? key,
    required this.controllerPhone,
  }) : super(key: key);

  final TextEditingController controllerPhone;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerPhone,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        fillColor: authTextFromFieldFillColor.withOpacity(.3),
        hintText: 'Phone Number',
        hintStyle: const TextStyle(
          color: authTextFromFieldHintTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.phone_outlined),
        suffixIcon: const Text(""),
        filled: true,
      ),
      validator: (value, {int i = 1}) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Phone number.';
        }
        if (!RegExp(
                r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
            .hasMatch(value)) {
          return 'Please enter an valid phone number';
        }
        return null;
      },
    );
  }
}
