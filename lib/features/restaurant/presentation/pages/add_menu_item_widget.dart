import 'package:flutter/material.dart';
import 'package:order/features/restaurant/data/model/menu_model.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMenuItemWidget extends StatefulWidget {
  final String restaurantId;

  const AddMenuItemWidget({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _AddMenuItemWidgetState createState() => _AddMenuItemWidgetState();
}

class _AddMenuItemWidgetState extends State<AddMenuItemWidget> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemDescriptionController,
                decoration: const InputDecoration(labelText: 'Item Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemPriceController,
                decoration: const InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final menuModel = MenuModel(
                      name: _itemNameController.text,
                      description: _itemDescriptionController.text,
                      price: double.parse(_itemPriceController.text).toInt(),
                    );
                    context.read<RestaurantCubit>().addMenuItems(   menuModel);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Menu Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
