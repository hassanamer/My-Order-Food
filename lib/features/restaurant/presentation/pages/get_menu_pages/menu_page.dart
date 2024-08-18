import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class MenuPage extends StatefulWidget {
  final String? restaurantName;
  final String? createdBy;

  MenuPage({
    super.key,
    this.restaurantName,
    this.createdBy,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ImagePicker _picker = ImagePicker();
  final RestaurantCubit _restaurantCubit = RestaurantCubit();
  late final String currentUserId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _restaurantCubit,
      child: Scaffold(
        backgroundColor: Colors.blue[600],
        appBar: AppBarWidget(
          pageName: '${widget.restaurantName} Menu',
        ),
        body: StreamBuilder<Map<String, String>>(
          stream: _restaurantCubit.menuImagesStream(widget.restaurantName!),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No images available'));
            }

            final Map<String, String> restaurantImages = snapshot.data!;

            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: restaurantImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = restaurantImages.keys.elementAt(index);
                            return Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: InteractiveViewer(
                                    panEnabled: true,
                                    boundaryMargin: const EdgeInsets.all(20.0),
                                    minScale: 0.5,
                                    maxScale: 3,
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(
                                          restaurantImages[key]!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (currentUserId == widget.createdBy)
                                  Positioned(
                                    top: 15,
                                    right: 15,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[300],
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          bool confirm =
                                              await _confirmDelete(context);
                                          if (confirm) {
                                            _restaurantCubit.deleteMenuImage(
                                                widget.restaurantName!, key);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: CommonElevatedButtonWidget(
                    width: MediaQuery.of(context).size.width / 7,
                    color: Colors.blue.shade300,
                    text: 'Update The Menu',
                    onPressed: () async {
                      setState(
                        () {
                          _isLoading = true;
                        },
                      );

                      final List<XFile>? pickedImages =
                          await _picker.pickMultiImage();
                      if (pickedImages != null) {
                        Uuid uuid = const Uuid();
                        Map<String, File> imagesToUpload = <String, File>{};
                        for (XFile file in pickedImages) {
                          String key = uuid.v4();
                          imagesToUpload[key] = File(file.path);
                        }
                        _restaurantCubit.updateMenuImage(
                            widget.restaurantName!, imagesToUpload);
                      }
                      setState(() {
                        _isLoading = false; // Set loading to false
                      });
                    },
                  ),
                ),
                if (_isLoading) const Center(child: LoadingWidget()),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this image?'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyles.font18BlueBold,
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyles.font18BlueBold,
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }
}
