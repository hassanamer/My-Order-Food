import 'package:flutter/material.dart';

class RestaurantTextFieldWidget extends StatelessWidget {
  const RestaurantTextFieldWidget({
    Key? key,
    required this.controllerRestaurant,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController controllerRestaurant;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labelText,
        prefixIcon: const Icon(Icons.restaurant_outlined),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return 'please fill this form';
        }
      },
      controller: controllerRestaurant,
    );
  }
}
