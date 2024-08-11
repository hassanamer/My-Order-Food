import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/widgets/loading_widget.dart';

import '../../../../../core/widgets/app_bar_widget.dart';
import '../../../../../core/widgets/common_elevated_button_widget.dart';
import '../../cubit/restaurant_cubit.dart';
import '../../cubit/restaurant_state.dart';

class MenuuPagee extends StatefulWidget {
  String? restaurantImage;
  final String? restaurantName;

  MenuuPagee({super.key, this.restaurantImage, this.restaurantName});

  @override
  State<MenuuPagee> createState() => _MenuuPageeState();
}

class _MenuuPageeState extends State<MenuuPagee> {
  final ImagePicker _picker = ImagePicker();
  final RestaurantCubit _restaurantCubit = RestaurantCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _restaurantCubit,
      child: Scaffold(
        appBar: AppBarWidget(
          pageName: " ${widget.restaurantName} Menu",
        ),
        body: BlocConsumer<RestaurantCubit, RestaurantState>(
          listener: (context, state) {
            if (state is MenuImageUpdatedState) {
              setState(() {
                widget.restaurantImage = state.newImageUrl;
              });
            } else if (state is RestaurantError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: EdgeInsets.all(20.0),
                        minScale: 0.5,
                        maxScale: 3,
                        clipBehavior: Clip.hardEdge,
                        child: Center(
                          child: widget.restaurantImage != null
                              ? Image.network(widget.restaurantImage!)
                              : Text("No image available"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (state is RestaurantLoading)
                      Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                                color: Colors.white.withOpacity(0.5),
                                child: LoadingWidget()),
                          ),
                        ],
                      )
                    else
                      CommonElevatedButtonWidget(
                        text: 'Update The Menu',
                        onPressed: () async {
                          XFile? pickedImage = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedImage != null) {
                            File imageFile = File('');
                            imageFile = File(pickedImage.path);
                            _restaurantCubit.updateMenuImage(
                                widget.restaurantName!, imageFile);
                          }
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
