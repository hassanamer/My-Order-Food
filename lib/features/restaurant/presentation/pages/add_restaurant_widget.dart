import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/widget/header_container_add_restaurant_widget.dart';
import 'package:order/features/restaurant/presentation/pages/widget/hotline_restaurant_textfield_widget.dart';
import 'package:order/features/restaurant/presentation/pages/widget/restaurant_textfield_widget.dart';

class RestaurantWidget extends StatefulWidget {
  const RestaurantWidget({super.key});

  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  bool isPressed = false;
  File? _restaurantImage; // Variable to hold selected image file

  final TextEditingController controllerRestaurantname =
      TextEditingController();
  final TextEditingController _controllerRestaurantDescription =
      TextEditingController();
  final TextEditingController controllerRestaurantHotline =
      TextEditingController();
  late final GlobalKey<FormState> keyForm;

  @override
  void initState() {
    keyForm = GlobalKey<FormState>();
    super.initState();
  }

  // Function to pick an image from gallery
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _restaurantImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 12);
    const divider = Divider(
      thickness: 1,
      indent: 30,
      endIndent: 30,
      color: Colors.amber,
    );
    return Form(
      key: keyForm,
      child: ListView(children: [
        sizedBox,
        divider,
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UnderlineTextWidget(text: "- Restaurant Details."),
              sizedBox,
              RestaurantTextFieldWidget(
                  controllerRestaurant: controllerRestaurantname,
                  labelText: "Name"),
              sizedBox,
              RestaurantTextFieldWidget(
                  controllerRestaurant: _controllerRestaurantDescription,
                  labelText: "Description"),
              sizedBox,
              HotLineRestaurantTextFieldWidget(
                  controllerRestaurantHotline: controllerRestaurantHotline),
            ],
          ),
        ),
        sizedBox,
        divider,
        CommonElevatedButtonWidget(
          text: 'Upload restaurant picture',
          onPressed: () async {
            await pickImage(); // Call function to pick image
            // Optionally, you can upload the image to Firebase Storage here
          },
        ),
        SizedBox(
          height: 10.h,
        ),
        CommonElevatedButtonWidget(
          text: "Add restaurant",
          onPressed: () {
            setState(() {
              if (keyForm.currentState!.validate() &&
                  _restaurantImage != null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Restaurant added successfully")));
                context.read<RestaurantCubit>().addRestaurant(
                      RestaurantModel(
                        restaurantName: controllerRestaurantname.text,
                        restaurantDescription:
                            _controllerRestaurantDescription.text,
                        hotlineNum: controllerRestaurantHotline.text,
                      ),
                      _restaurantImage!, // Pass the image file to the cubit
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Please upload a picture")));
              }
            });
          },
        )
      ]),
    );
  }
}
