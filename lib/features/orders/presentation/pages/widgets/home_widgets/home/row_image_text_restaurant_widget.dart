import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/menu_page.dart';

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
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.restaurantModel.length,
        itemBuilder: (BuildContext context, int index) {
          final RestaurantModel restaurant = widget.restaurantModel[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () async {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => MenuPage(
                      createdBy: restaurant.createdBy,
                      restaurantName: restaurant.restaurantName,
                      // restaurantImages: restaurant.imageURLs,
                    ),
                  ),
                )
                    // ignore: always_specify_types
                    .then((value) {
                  setState(() {
                    context.read<RestaurantCubit>().getAllRestaurants();
                  });
                });
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/restaurant.png',
                          width: 70,
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        restaurant.restaurantName,
                        style: TextStyles.font18WhiteBold,
                      ),
                    ),
                  ]),
            ),
          );
        });
  }
}
