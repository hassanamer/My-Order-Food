import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class MobileTextFieldWidget extends StatelessWidget {
  const MobileTextFieldWidget({
    required this.controllerPhone,
    super.key,
  });

  final TextEditingController controllerPhone;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerPhone,
      keyboardType: TextInputType.number,
      style: TextStyles.font20BlueGradienteBoldForItemsList,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(.9),
        hintText: 'Phone Number',
        hintStyle: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
          color: Colors.blue.shade900.withOpacity(.3),
        ),
        label: Text(
          'Phone Number',
          style: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
            color: Colors.blue.shade900.withOpacity(.3),
          ),
        ),
        prefixIcon: Icon(
          Icons.phone_outlined,
          color: Colors.blue.shade900,
        ),
        suffixIcon: const Text(''),
        filled: true,
      ),
      validator: (String? value, {int i = 1}) {
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
