import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/home/custome_row_home_widget.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/orders/orders_list_title_widget.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/restaurants/get_restaurant_row_widget.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';

class HomePageOrdersWidget extends StatefulWidget {
  final List<OrderEntity> orderEntity;

  const HomePageOrdersWidget({required this.orderEntity, super.key});

  @override
  State<HomePageOrdersWidget> createState() => _HomePageOrdersWidgetState();
}

class _HomePageOrdersWidgetState extends State<HomePageOrdersWidget> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> _refresh() async {
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
    // ignore: always_specify_types
    return await Future.delayed(
      const Duration(seconds: 0),
    );
  }

  Divider divider = const Divider(
    thickness: 1,
    height: 3,
  );

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedToday = DateFormat('yyyy-MM-dd').format(today);

    List<OrderEntity> todayOrders =
        widget.orderEntity.where((OrderEntity order) {
      String orderDate = DateFormat('yyyy-MM-dd').format(order.createdAt);
      return orderDate == formattedToday;
    }).toList();

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: CustomRowHomePage(
                firstText: 'Restaurant',
                secondText: 'See More',
                press: () {
                  Navigator.of(context).push(MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          const AllRestaurantPage()));
                }),
          ),
          const SizedBox(
            height: 8,
          ),
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: GetRestaurantRowWidget(),
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text('Orders of Today',
                                style: TextStyles.font22WhiteBold),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Center(
                        child: ListView.separated(
                          itemCount: todayOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return OrdersListTitleWidget(
                              title: todayOrders[index].title ?? '',
                              orderEntity: todayOrders[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              divider,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
