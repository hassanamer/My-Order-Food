import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String name;
  final bool multiLines;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final Function(PointerDownEvent)? onTapOutside;

  const TextFormFieldWidget({
    Key? key,
    required this.name,
    required this.multiLines,
    required this.controller,
    this.validator,
    this.onTap,
    this.onEditingComplete,
    this.onTapOutside,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FocusScope(
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              if (onTapOutside != null) {
                onTapOutside!(PointerDownEvent());
              }
            }
          },
          child: TextFormField(
            controller: controller,
            maxLines: multiLines ? null : 1,
            decoration: InputDecoration(
              labelText: name,
              border: OutlineInputBorder(),
            ),
            validator: validator,
            onEditingComplete: onEditingComplete,
          ),
        ),
      ),
    );
  }
}
