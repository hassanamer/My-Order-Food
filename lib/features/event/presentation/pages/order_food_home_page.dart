import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/cart/presentation/pages/cart_page.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/event/presentation/cubit/order_state.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/home/home_page_app_bar_title_widget.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/orders/orders_empty_list_widget.dart';

import 'widgets/home_widgets/orders/home_page_order_widget.dart';

class OrderFoodHomePage extends StatefulWidget {
  const OrderFoodHomePage({super.key});

  @override
  State<OrderFoodHomePage> createState() => _OrderFoodHomePageState();
}

class _OrderFoodHomePageState extends State<OrderFoodHomePage> {
  @override
  void initState() {
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleWidget: const HomePageAppBarTitleWidget(),
        hideBackButton: true,
        actions: [
          Badge(
            child: IconButton(
              onPressed: () {
                context.read<CartCubit>().getAllCartItems();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartPage()));
              },
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccessState) {
            context.read<OrderCubit>().getAllOrders();
          }
          if (state is OrderErrorState) {
            if (kDebugMode) {
              print(state.errorMessage);
            }
          }
          if (state is OrderLoadedState) {
            print(state.orderEntity);
          }
        },
        builder: (context, state) {
          if (state is OrderLoadedState) {
            if (state.orderEntity.isEmpty) {
              return const OrdersEmptyListWidget();
            } else {
              return HomePageOrdersWidget(
                orderEntity: state.orderEntity,
                // UserEntity: state.UserEntity,
              );
            }
          } else if (state is OrderErrorState) {
            if (kDebugMode) {
              print(state.errorMessage);
            }
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
