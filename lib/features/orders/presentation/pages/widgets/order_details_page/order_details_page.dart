import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_add_order_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_user_orders_usecase.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_details_page/order_details_body.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/injection_container.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  late OrderEntity orderEntity;

  OrderDetailsPage({
    required this.orderEntity,
    super.key,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late GetUsersUsecase getUserOrderUsecase;
  late AddOrderUsecase addOrderUsecase;
  late String createdAt;
  User? currentUser = FirebaseAuth.instance.currentUser;

  bool isCreator = false;
  late Future<Map<String, RegisterAccountModel>> userMapFuture;
  late Stream<OrderEntity> _orderStream;
  String itemName = '';
  int itemCount = 0;
  final TextEditingController _itemController = TextEditingController();

  void onCalculatePressed() {
    refreshOrder();
  }

  void setItemName(String value) {
    setState(() {
      itemName = value;
    });
  }

  void setItemCount(int value) {
    setState(() {
      itemCount = value;
    });
  }

  Future<Map<String, RegisterAccountModel>> loadUsers(
      List<String> userIds) async {
    return await getUserOrderUsecase.getUsers(userIds);
  }

  Map<String, List<OrderItemModel>> getItemsGroupedByUsers(
      List<OrderItemModel> itemsList) {
    Map<String, List<OrderItemModel>> itemsGroupedByUser =
        <String, List<OrderItemModel>>{};
    for (OrderItemModel item in itemsList) {
      itemsGroupedByUser
          .putIfAbsent(item.userId, () => <OrderItemModel>[])
          .add(item);
    }
    return itemsGroupedByUser;
  }

  @override
  initState() {
    super.initState();
    addOrderUsecase = sl();
    getUserOrderUsecase = sl();
    // ignore: unnecessary_null_comparison
    createdAt = widget.orderEntity.createdAt != null
        ? DateFormat('yyyy-MM-dd hh:mm a').format(widget.orderEntity.createdAt)
        : 'Unknown';
    isCreator = currentUser?.uid == widget.orderEntity.userId;
    _orderStream = OrderCubit().getOrderStream(widget.orderEntity.id);
  }

  refreshOrder() async {
    widget.orderEntity =
        await addOrderUsecase.remoteGetOrder(widget.orderEntity.id);
    // updateOrdersAndUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      appBar: AppBarWidget(
        pageName: widget.orderEntity.title ?? '',
      ),
      body: StreamBuilder<OrderEntity>(
        stream: _orderStream,
        builder: (BuildContext context, AsyncSnapshot<OrderEntity> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Order not found.'));
          }

          List<OrderItemModel> itemsList =
              snapshot.data!.items ?? <OrderItemModel>[];
          Map<String, List<OrderItemModel>> itemsGroupedByUser =
              getItemsGroupedByUsers(itemsList);
          userMapFuture = loadUsers(itemsGroupedByUser.keys.toList());

          return OrderDetailsBody(
            orderEntity: widget.orderEntity,
            itemsGroupedByUser: itemsGroupedByUser,
            userMapFuture: userMapFuture,
            isCreator: isCreator,
            onCalculatePressed: onCalculatePressed,
            itemName: itemName,
            setItemName: setItemName,
            itemCount: itemCount,
            setItemCount: setItemCount,
            itemController: _itemController,
            itemsList: itemsList,
          );
        },
      ),
    );
  }
}
