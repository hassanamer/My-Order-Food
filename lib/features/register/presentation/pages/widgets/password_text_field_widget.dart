import 'package:flutter/material.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/theme_app.dart';

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
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        fillColor: authTextFromFieldFillColor.withOpacity(.3),
        filled: true,
        hintText: 'Password',
        hintStyle: TextStyle(
          color: ColorsManager.darkBlue.withOpacity(.2),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: ColorsManager.darkBlue.withOpacity(.7),
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
