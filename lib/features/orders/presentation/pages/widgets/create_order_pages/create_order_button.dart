import 'package:flutter/material.dart';

class CreateOrderButton extends StatefulWidget {
  final void Function() onPressed;
  final bool isUpdateEvent;

  const CreateOrderButton({
    required this.onPressed,
    required this.isUpdateEvent,
    super.key,
  });

  @override
  _CreateOrderButtonState createState() => _CreateOrderButtonState();
}

class _CreateOrderButtonState extends State<CreateOrderButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isPressed
              ? <BoxShadow>[]
              : <BoxShadow>[
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.isUpdateEvent
                  ? const Icon(Icons.edit, color: Colors.white)
                  : const Icon(Icons.border_color_outlined,
                      color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Start Order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
