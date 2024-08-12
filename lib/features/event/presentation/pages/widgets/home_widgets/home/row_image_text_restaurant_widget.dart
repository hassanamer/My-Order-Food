import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/menuu_pagee.dart';

// ignore: must_be_immutable
class RowImageTextRestaurantWidget extends StatefulWidget {
  List<RestaurantModel> restaurantModel = <RestaurantModel>[];

  RowImageTextRestaurantWidget({required this.restaurantModel, super.key});

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
          itemBuilder: (BuildContext context, int index) {
            final RestaurantModel restaurant = widget.restaurantModel[index];
            return InkWell(
              onTap: () => Navigator.of(context)
                  .push(
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MenuuPagee(
                    restaurantName: restaurant.restaurantName,
                    restaurantImage: restaurant.imageURL,
                  ),
                ),
              )
                  // ignore: always_specify_types
                  .then((value) {
                setState(() {
                  context.read<RestaurantCubit>().getAllRestaurants();
                });
              }),
              child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/restaurant.png',
                    width: 70,
                    height: 80,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Colors.blueAccent, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    restaurant.restaurantName,
                    style: TextStyles.font16WhiteSemiBold,
                  ),
                ),
              ]),
            );
          }),
    );
  }
}
