import 'package:flutter/material.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/get_menu_page.dart';

import '../../../../../restaurant/data/model/restaurant_model.dart';

class RowImageTextRestaurantWidget extends StatefulWidget {
  final List<RestaurantModel> restaurantModel;
  const RowImageTextRestaurantWidget(
      {super.key, required this.restaurantModel});

  @override
  State<RowImageTextRestaurantWidget> createState() =>
      _RowImageTextRestaurantWidgetState();
}

class _RowImageTextRestaurantWidgetState
    extends State<RowImageTextRestaurantWidget> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.restaurantModel.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AllMenuPage())),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.all(5),
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
                Text(widget.restaurantModel[index].restaurantName),
              ]),
            );
          }),
    );
  }
}
