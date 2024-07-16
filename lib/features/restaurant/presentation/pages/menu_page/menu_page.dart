import 'dart:io';

import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  final File? restaurantImage; // Image file variable

  const MenuPage({Key? key, this.restaurantImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      body: Center(
        child: restaurantImage != null
            ? Image.file(restaurantImage!) // Display the selected image
            : Text('No image selected'), // Placeholder text if no image
      ),
    );
  }
}
