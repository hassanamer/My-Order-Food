import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';

import '../get_menu_pages/menuu_pagee.dart';

class AllRestaurantWidget extends StatefulWidget {
  final List<RestaurantModel> restaurantModel;
  final File? restaurantImage; // Image file variable

  const AllRestaurantWidget({
    Key? key,
    required this.restaurantModel,
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
    return Future.delayed(
      const Duration(seconds: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: AnimationLimiter(
        child: ListView.separated(
          itemCount: widget.restaurantModel.length,
          itemBuilder: (context, index) {
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
                        colors: [Colors.blue.shade400, Colors.blue.shade900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => MenuuPagee(
                              restaurantImage:
                                  widget.restaurantModel[index].imageURL,
                              restaurantName:
                                  widget.restaurantModel[index].restaurantName,
                            ),
                          ))
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(Icons.restaurant_menu,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget
                                        .restaurantModel[index].restaurantName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.description,
                                      color: Colors.white70),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.restaurantModel[index]
                                        .restaurantDescription,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.white70),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.restaurantModel[index].hotlineNum,
                                    style: TextStyles.font18WhiteBold,
                                  ),
                                ],
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
