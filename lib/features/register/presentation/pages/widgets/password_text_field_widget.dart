import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  const PasswordTextFieldWidget({
    required this.controllerPassword,
    super.key,
  });

  final TextEditingController controllerPassword;

  @override
  _PasswordTextFieldWidgetState createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _obscureText = true; // State variable to manage password visibility

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
      controller: widget.controllerPassword,
      style: TextStyles.font20BlueGradienteBoldForItemsList,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(.9),
        filled: true,
        hintText: 'Password',
        hintStyle: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
          color: Colors.blue.shade900.withOpacity(.3),
        ),
        label: Text(
          'Password',
          style: TextStyles.font20BlueGradienteBoldForItemsList.copyWith(
            color: Colors.blue.shade900.withOpacity(.3),
          ),
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          size: 24,
          color: Colors.blue.shade900,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue.shade900,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle visibility
            });
          },
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Password.';
        }
        if (!RegExp(r'^(?=.*[A-Z])[A-Za-z\d\S]{8,}$').hasMatch(value)) {
          return 'Please enter a valid password.\nYour password must be at least 8 characters long,\ncontaining at least one uppercase letter, one lowercase letter, and one number.';
        }

        return null;
      },
    );
  }
}
