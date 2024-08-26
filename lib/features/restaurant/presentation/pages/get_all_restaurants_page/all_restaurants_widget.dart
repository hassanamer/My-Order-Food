import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/menu_page.dart';

class AllRestaurantWidget extends StatefulWidget {
  final List<RestaurantModel> restaurantModel;
  final File? restaurantImage; // Image file variable

  const AllRestaurantWidget({
    required this.restaurantModel,
    super.key,
    this.restaurantImage,
  });

  @override
  State<AllRestaurantWidget> createState() => _AllRestaurantWidgetState();
}

class _AllRestaurantWidgetState extends State<AllRestaurantWidget> {
  Future<void> _refresh() async {
    setState(() {
      context.read<RestaurantCubit>().getAllRestaurants();
    });
    // ignore: always_specify_types
    return Future.delayed(
      const Duration(seconds: 0),
    );
  }

  Map<String, File> convertToFileMap(Map<String, String> urlMap) {
    final Map<String, File> fileMap = {};
    for (var entry in urlMap.entries) {
      fileMap[entry.key] =
          File(entry.value); // Convert URL to File if necessary
    }
    return fileMap;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: AnimationLimiter(
        child: ListView.separated(
          itemCount: widget.restaurantModel.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    margin: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white,
                          Colors.blue.shade200,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => MenuPage(
                              createdBy:
                                  widget.restaurantModel[index].createdBy,
                              restaurantName:
                                  widget.restaurantModel[index].restaurantName,
                            ),
                          ))
                              // ignore: always_specify_types
                              .then((value) {
                            setState(() {
                              context
                                  .read<RestaurantCubit>()
                                  .getAllRestaurants();
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.restaurant_menu,
                                          color: Colors.blue.shade900),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.restaurantModel[index]
                                            .restaurantName,
                                        style: TextStyles
                                            .font20BlueGradienteBoldForItemsList,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.description,
                                          color: Colors.blue.shade900),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.restaurantModel[index]
                                            .restaurantDescription,
                                        style: TextStyles
                                            .font20BlueGradienteBoldForItemsList,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.phone,
                                          color: Colors.blue.shade900),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget
                                            .restaurantModel[index].hotlineNum,
                                        style: TextStyles
                                            .font20BlueGradienteBoldForItemsList,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_circle_right,
                                color: Colors.blue.shade900,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(thickness: 1, color: Colors.white);
          },
        ),
      ),
    );
  }
}
