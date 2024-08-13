import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order/core/theming/theme_app.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/restaurants/get_restaurant_row_widget.dart';
import 'package:order/gen/assets.gen.dart';

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
    // ignore: always_specify_types
    return await Future.delayed(
      const Duration(seconds: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: <Widget>[
          const GetRestaurantRowWidget(),
          Flexible(
            flex: 3,
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      Assets.images.emptyList,
                      width: 221,
                      height: 182,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'There is no open orders at the moment..!  :) ',
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
