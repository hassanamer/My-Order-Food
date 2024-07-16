import 'package:flutter/material.dart';

class HotLineRestaurantTextFieldWidget extends StatelessWidget {
  const HotLineRestaurantTextFieldWidget({
    Key? key,
    required this.controllerRestaurantHotline,
  }) : super(key: key);

  final TextEditingController controllerRestaurantHotline;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Hotline',
        prefixIcon: Icon(Icons.phone),
      ),
      controller: controllerRestaurantHotline,
    );
  }
}
