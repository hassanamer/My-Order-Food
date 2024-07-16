import 'package:flutter/material.dart';

class AlertDialogHandlerWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AlertDialogHandlerWidget({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "No",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
