import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/widget/hotline_restaurant_textfield_widget.dart';
import 'package:order/features/restaurant/presentation/pages/widget/restaurant_textfield_widget.dart';
import 'package:uuid/uuid.dart'; // Add the uuid package for generating unique keys

class RestaurantWidget extends StatefulWidget {
  const RestaurantWidget({super.key});

  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  bool isPressed = false;
  Map<String, File>? _restaurantImages = <String, File>{};
  final String CurrentuUserId = FirebaseAuth.instance.currentUser!.uid;

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

  Future<void> pickImage() async {
    final List<XFile>? pickedFiles =
        await ImagePicker().pickMultiImage(); // Pick multiple images
    if (pickedFiles != null) {
      setState(() {
        Uuid uuid = const Uuid();
        for (XFile file in pickedFiles) {
          String key = uuid.v4(); // Generate a unique key for each image
          _restaurantImages![key] = File(file.path); // Add image to the map
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox sizedBox = SizedBox(height: 12);
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Form(
      key: keyForm,
      child: ListView(children: <Widget>[
        sizedBox,
        Container(
          decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Restaurant Details',
                style: TextStyles.font25WhiteBold,
              ),
              sizedBox,
              RestaurantTextFieldWidget(
                  controllerRestaurant: controllerRestaurantname,
                  labelText: 'Name'),
              sizedBox,
              RestaurantTextFieldWidget(
                  controllerRestaurant: _controllerRestaurantDescription,
                  labelText: 'Description'),
              sizedBox,
              HotLineRestaurantTextFieldWidget(
                  controllerRestaurantHotline: controllerRestaurantHotline),
            ],
          ),
        ),
        sizedBox,
        Column(
          children: <Widget>[
            CommonElevatedButtonWidget(
              width: buttonWidth,
              text: 'Upload restaurant picture',
              onPressed: () async {
                await pickImage(); // Call function to pick image
              },
            ),
            const SizedBox(
              height: 5,
            ),
            _buildImagePreview(), // Display selected images
            SizedBox(
              height: 10.h,
            ),
            CommonElevatedButtonWidget(
              width: buttonWidth,
              text: 'Add restaurant',
              onPressed: () {
                setState(() {
                  if (keyForm.currentState!.validate() &&
                      _restaurantImages!.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Restaurant added successfully')));
                    context.read<RestaurantCubit>().addRestaurant(
                          RestaurantModel(
                            restaurantName: controllerRestaurantname.text,
                            restaurantDescription:
                                _controllerRestaurantDescription.text,
                            hotlineNum: controllerRestaurantHotline.text,
                            createdBy: CurrentuUserId,
                          ),
                          _restaurantImages, // Pass the image file to the cubit
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please upload a picture')));
                  }
                });
              },
            )
          ],
        )
      ]),
    );
  }

  Widget _buildImagePreview() {
    return _restaurantImages != null && _restaurantImages!.isNotEmpty
        ? SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _restaurantImages!.length,
              itemBuilder: (BuildContext context, int index) {
                String key = _restaurantImages!.keys.elementAt(index);
                File imageFile = _restaurantImages![key]!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.file(
                    imageFile,
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          )
        : const SizedBox.shrink();
  }
}
