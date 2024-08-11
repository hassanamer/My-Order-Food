import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/orders/orders_list_title_widget.dart';

import '../../../../../../restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';
import '../home/custome_row_home_widget.dart';
import '../restaurants/get_restaurant_row_widget.dart';

class HomePageOrdersWidget extends StatefulWidget {
  final List<OrderEntity> orderEntity;

  const HomePageOrdersWidget({Key? key, required this.orderEntity})
      : super(key: key);

  @override
  State<HomePageOrdersWidget> createState() => _HomePageOrdersWidgetState();
}

class _HomePageOrdersWidgetState extends State<HomePageOrdersWidget> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    const divider = Divider(
      thickness: 1,
      height: 3,
    );

    DateTime today = DateTime.now();
    String formattedToday = DateFormat('yyyy-MM-dd').format(today);

    List<OrderEntity> todayOrders = widget.orderEntity.where((order) {
      String orderDate = DateFormat('yyyy-MM-dd').format(order.createdAt);
      return orderDate == formattedToday;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: CustomRowHomePage(
                    firstText: 'Restaurant',
                    secondText: 'See More',
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AllRestaurantPage()));
                    }),
              ),
              const SizedBox(
                height: 5,
              ),
              const GetRestaurantRowWidget(),
              divider,
              Flexible(
                flex: 3,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: todayOrders.length,
                    itemBuilder: (context, index) {
                      return OrdersListTitleWidget(
                        title: todayOrders[index].title ?? '',
                        orderEntity: todayOrders[index],
                      );
                    },
                    separatorBuilder: (context, index) => divider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
