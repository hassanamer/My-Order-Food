import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class HotLineRestaurantTextFieldWidget extends StatelessWidget {
  const HotLineRestaurantTextFieldWidget({
    required this.controllerRestaurantHotline,
    super.key,
  });

  final TextEditingController controllerRestaurantHotline;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelStyle: TextStyles.font16WhiteSemiBold,
        label: Text('Hotline'),
        hintText: 'Hotline',
        hintStyle: TextStyles.font16WhiteSemiBold,
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.white,
        ),
      ),
      controller: controllerRestaurantHotline,
    );
  }
}
