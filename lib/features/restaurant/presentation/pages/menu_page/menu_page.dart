import 'dart:io';

import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  final File? restaurantImage; // Image file variable

  const MenuPage({super.key, this.restaurantImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Page'),
      ),
      body: Center(
        child: restaurantImage != null
            ? Image.file(restaurantImage!) // Display the selected image
            : const Text('No image selected'), // Placeholder text if no image
      ),
    );
  }
}
