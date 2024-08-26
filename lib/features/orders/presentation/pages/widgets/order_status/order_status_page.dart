import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/cubit/order_state.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_item_view.dart';

class OrderStatusPage extends StatefulWidget {
  final OrderEntity orderEntity;

  const OrderStatusPage({required this.orderEntity, super.key});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme themeColors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: themeColors.surface,
      appBar: const AppBarWidget(
        pageName: 'Order Status',
        hideBackButton: false,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (BuildContext context, OrderState state) {
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
        builder: (BuildContext context, OrderState state) {
          if (state is OrderLoadedState) {
            return ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 48,
                bottom: 16,
              ),
              children: <Widget>[
                ...OrderStatusEnum.values.mapIndexed(
                  (int i, OrderStatusEnum e) => OrderStatusItemView(
                    color: e.color,
                    title: e.title,
                    subtitle: e.descreption,
                    icon: e.icon,
                    showLine: i < OrderStatusEnum.values.length - 1,
                    isActive: OrderStatusEnum.values
                            .indexOf(widget.orderEntity.status) >=
                        i,
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: <Widget>[
              Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const LoadingWidget()),
            ],
          );
        },
      ),
    );
  }
}
