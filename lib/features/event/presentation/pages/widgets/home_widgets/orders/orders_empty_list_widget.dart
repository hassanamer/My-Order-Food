import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order/core/theme_app.dart';

import '../../../../../../../gen/assets.gen.dart';
import '../../../../cubit/order_cubit.dart';
import '../restaurants/get_restaurant_row_widget.dart';

class OrdersEmptyListWidget extends StatefulWidget {
  const OrdersEmptyListWidget({super.key});

  @override
  State<OrdersEmptyListWidget> createState() => _OrdersEmptyListWidgetState();
}

class _OrdersEmptyListWidgetState extends State<OrdersEmptyListWidget> {
  Future<void> _refresh() async {
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
    return await Future.delayed(
      const Duration(seconds: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          const GetRestaurantRowWidget(),
          Flexible(
            flex: 3,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.images.emptyList,
                      width: 221,
                      height: 182,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "There is no open orders at the moment..!  :) ",
                      style: TextStyle(color: appTheme.primaryColor),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
