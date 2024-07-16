import 'package:flutter/material.dart';

class FormSubmitBtn extends StatefulWidget {
  final void Function() onPressed;
  final bool isUpdateEvent;

  const FormSubmitBtn({
    Key? key,
    required this.onPressed,
    required this.isUpdateEvent,
  }) : super(key: key);

  @override
  _FormSubmitBtnState createState() => _FormSubmitBtnState();
}

class _FormSubmitBtnState extends State<FormSubmitBtn> {
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
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isPressed
                ? [Colors.blue[800]!, Colors.blue[600]!]
                : [Colors.blue[600]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isUpdateEvent
                  ? Icon(Icons.edit, color: Colors.white)
                  : Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                widget.isUpdateEvent ? "Update" : "Add",
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
