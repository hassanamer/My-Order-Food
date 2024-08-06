import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/menuu_pagee.dart';

import '../../../../../../restaurant/data/model/restaurant_model.dart';
import '../../../../../../restaurant/presentation/cubit/restaurant_cubit.dart';

class RowImageTextRestaurantWidget extends StatefulWidget {
  List<RestaurantModel> restaurantModel = [];

  RowImageTextRestaurantWidget({super.key, required this.restaurantModel});

  @override
  State<RowImageTextRestaurantWidget> createState() =>
      _RowImageTextRestaurantWidgetState();
}

class _RowImageTextRestaurantWidgetState
    extends State<RowImageTextRestaurantWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.restaurantModel.length,
          itemBuilder: (context, index) {
            final restaurant = widget.restaurantModel[index];
            return InkWell(
              onTap: () => Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => MenuuPagee(
                    restaurantName: restaurant.restaurantName,
                    restaurantImage: restaurant.imageURL,
                  ),
                ),
              )
                  .then((value) {
                setState(() {
                  context.read<RestaurantCubit>().getAllRestaurants();
                });
              }),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    "assets/images/restaurant.png",
                    width: 70,
                    height: 80,
                  ),
                ),
                Text(restaurant.restaurantName),
              ]),
            );
          }),
    );
  }
}
