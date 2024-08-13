import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/core/widgets/persistent_bottom_nav_bar_widget.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/cubit/order_state.dart';
import 'package:order/features/orders/presentation/pages/widgets/create_order_pages/create_order_widget.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/home/order_food_home_page.dart';

class CreateOrderPage extends StatelessWidget {
  final OrderEntity? eventEntity;
  final bool isUpdateEvent;

  const CreateOrderPage({
    required this.isUpdateEvent,
    super.key,
    this.eventEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: 'Start A New Order',
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<OrderCubit, OrderState>(
          listener: (BuildContext context, OrderState state) {
            if (state is OrderSuccessState) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<dynamic>(
                    builder: (_) => const OrderFoodHomePage()),
              );
              Get.to(() => const NavBarWidget());
            } else if (state is OrderErrorState) {
              final SnackBar snackBar =
                  SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (BuildContext context, OrderState state) {
            if (state is OrderLoadingState) {
              return Stack(
                children: <Widget>[
                  Container(
                      color: Colors.white.withOpacity(0.5),
                      child: const LoadingWidget()),
                ],
              );
            }
            return SingleChildScrollView(
              child: CreateOrderWidget(
                isUpdateEvent: isUpdateEvent,
                eventEntity: isUpdateEvent ? eventEntity : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
