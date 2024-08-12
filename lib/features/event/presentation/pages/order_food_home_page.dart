import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/home/home_page_app_bar_title_widget.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/orders/orders_empty_list_widget.dart';

import '../../../../core/services/notification_cubit.dart';
import 'widgets/home_widgets/orders/home_page_order_widget.dart';

class OrderFoodHomePage extends StatefulWidget {
  const OrderFoodHomePage({super.key});

  @override
  State<OrderFoodHomePage> createState() => _OrderFoodHomePageState();
}

class _OrderFoodHomePageState extends State<OrderFoodHomePage> {
  late Stream<List<OrderEntity>> _ordersStream;

  @override
  void initState() {
    super.initState();
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
    _ordersStream = OrderCubit().getOrdersStream();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titleWidget: HomePageAppBarTitleWidget(),
        hideBackButton: true,
      ),
      body: StreamBuilder<List<OrderEntity>>(
          stream: _ordersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingWidget());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const OrdersEmptyListWidget();
            }
            final orders = snapshot.data!;
            return HomePageOrdersWidget(
              orderEntity: orders,
            );
          }),
    );
  }
}
