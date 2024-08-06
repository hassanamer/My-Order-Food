import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

import '../../../../../../core/widgets/loading_widget.dart';
import '../../../cubit/order_cubit.dart';
import '../../../cubit/order_state.dart';
import 'order_status_item_view.dart';

class Enums extends StatefulWidget {
  final OrderEntity orderEntity;

  const Enums({Key? key, required this.orderEntity}) : super(key: key);

  @override
  State<Enums> createState() => _EnumsState();
}

class _EnumsState extends State<Enums> {
  @override
  void initState() {
    super.initState();
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: const AppBarWidget(
        pageName: "Order Status",
        hideBackButton: false,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
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
            return ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 48,
                bottom: 16,
              ),
              children: [
                ...OrderStatusEnum.values
                    .mapIndexed(
                      (i, e) => OrderStatusItemView(
                        color: e.color,
                        title: e.title,
                        subtitle: e.descreption,
                        icon: e.icon,
                        showLine: i < OrderStatusEnum.values.length - 1,
                        isActive: OrderStatusEnum.values
                                .indexOf(widget.orderEntity.status) >=
                            i,
                      ),
                    )
                    .toList(),
              ],
            );
          }
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                color: Colors.white.withOpacity(0.5), child: LoadingWidget()),
          );
        },
      ),
    );
  }
}
