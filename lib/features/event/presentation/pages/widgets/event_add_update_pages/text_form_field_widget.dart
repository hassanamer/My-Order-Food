import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String name;
  final bool multiLines;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const TextFormFieldWidget({
    Key? key,
    required this.name,
    required this.multiLines,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: multiLines ? null : 1,
      decoration: InputDecoration(
        labelText: name,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
