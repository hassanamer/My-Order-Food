import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:order/core/services/push_notification_service.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/cart/presentation/pages/view_order_page.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/remote_usecases/add_order_usecase.dart';
import 'package:order/features/event/domain/remote_usecases/remote_get_user_order.dart';
import 'package:order/features/event/presentation/pages/widgets/order_details_page/order_details_page_item_tile.dart';
import 'package:order/injection_container.dart';

import '../../../../../../core/services/notification_service.dart';
import '../../../../../../core/widgets/common_elevated_button_widget.dart';
import '../../../../../register/data/models/register_account_model.dart';

class OrderDetailsPage extends StatefulWidget {
  late OrderEntity orderEntity;

  OrderDetailsPage({
    Key? key,
    required this.orderEntity,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late GetUserUsecase getUserOrderUsecase;
  late AddOrderUsecase addOrderUsecase;
  late String createdAt;
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool _hasItemsBeenAdded = false;
  double keyboardHeight = 0;
  List<OrderItem> itemsList = [];
  TextEditingController itemController = TextEditingController();
  int itemCount = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  Map<String, RegisterAccountModel> userMap = {};
  bool isLoading = true;
  RegisterAccountModel? placer;
  RegisterAccountModel? receiver;
  bool isCreator = false;

  void onCalculatePressed() {
    refreshOrder();
  }

  void _handleItemAdded() {
    _hasItemsBeenAdded = true;
  }

  updateOrdersAndUsers() {
    userMap = {};
    itemsGroupedByUser = {};
    for (var item in itemsList) {
      itemsGroupedByUser.putIfAbsent(item.userId, () => []).add(item);
    }
    getUserOrderUsecase
        .getUsers(itemsGroupedByUser.keys.toList())
        .then((userMap) {
      setState(() {
        this.userMap = userMap;
        isLoading = false;
      });
    });
  }

  @override
  initState() {
    super.initState();
    addOrderUsecase = sl();
    getUserOrderUsecase = sl();
    itemsList = widget.orderEntity.items ?? [];
    updateOrdersAndUsers();
    createdAt = widget.orderEntity.createdAt != null
        ? DateFormat('yyyy-MM-dd hh:mm a').format(widget.orderEntity.createdAt)
        : 'Unknown';

    isCreator = currentUser?.uid == widget.orderEntity.userId;
  }

  refreshOrder() async {
    widget.orderEntity =
        await addOrderUsecase.remoteGetOrder(widget.orderEntity.id);
    updateOrdersAndUsers();
  }

  updateOrderStatus() {
    addOrderUsecase.updateOrderStatus(
        widget.orderEntity.id, widget.orderEntity.status);
  }

  Future<void> assignUsersAndNotify() async {
    List<RegisterAccountModel> usersInOrder = userMap.values.toList();
    usersInOrder
        .sort((a, b) => a.placedOrderCount!.compareTo(b.placedOrderCount!));

    placer = null;
    receiver = null;

    for (var user in usersInOrder) {
      if (placer == null &&
          user.deliveryPreference == "Place the order" &&
          user.hasCar == "No") {
        placer = user;
      } else if (receiver == null && user.hasCar == "Yes" ||
          user.deliveryPreference == "Receive it at the gate") {
        receiver = user;
      }

      if (placer != null && receiver != null) {
        break;
      }
    }

    if (placer != null) {
      await placer!.incrementPlacedOrderCount();
      await _firestore
          .collection('Users')
          .doc(placer!.userId)
          .update(placer!.toMap());
      PushNotificationService.sendNotificationToUser(placer!.userId,
          "You're Choosed To Place The Order, Thank You So Much For Your Help");
      NotificationService.saveNotification("You're Choosed To Place The Order",
          "Thank You So Much For Your Help", placer!.userId);
    }

    if (receiver != null) {
      await receiver!.incrementReceivedOrderCount();
      await _firestore
          .collection('Users')
          .doc(receiver!.userId)
          .update(receiver!.toMap());
      PushNotificationService.sendNotificationToUser(receiver!.userId,
          "You're Choosed To Rcieve The Order At The Gate, Thank You So Much For Your Help");
      NotificationService.saveNotification(
          "You're Choosed To Rcieve The Order At The Gate",
          "Thank You So Much For Your Help",
          receiver!.userId);
    }

    setState(() {});
  }

  Future<void> _deleteItem(OrderItem item) async {
    setState(() {
      itemsList.remove(item);
      itemsGroupedByUser[item.userId]?.remove(item);
      if (itemsGroupedByUser[item.userId]?.isEmpty ?? false) {
        itemsGroupedByUser.remove(item.userId);
      }
    });

    await addOrderUsecase.update(widget.orderEntity);
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      thickness: 1,
      height: 3,
    );
    bool isCurrentUserPlacerOrReceiver = currentUser != null &&
        (currentUser!.uid == placer?.userId ||
            currentUser!.uid == receiver?.userId);
    return Scaffold(
      appBar: AppBarWidget(
        pageName: widget.orderEntity.title ?? '',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Created At : $createdAt",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: itemsGroupedByUser.length,
                itemBuilder: (context, index) {
                  String userId = itemsGroupedByUser.keys.elementAt(index);
                  List<OrderItem> userItems = itemsGroupedByUser[userId]!;
                  return EventDetailPageItemTile(
                    userId: userId,
                    orderEntity: widget.orderEntity,
                    items: userItems,
                    user: userMap[userId],
                    status: widget.orderEntity.status,
                    onDeleteItem: (item) => _deleteItem(item),
                  );
                },
                separatorBuilder: (context, index) => divider,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible:
                        widget.orderEntity.status == OrderStatusEnum.active &&
                            (isCreator || isCurrentUserPlacerOrReceiver),
                    child: CommonElevatedButtonWidget(
                      text: 'Place Your Order...',
                      width: 100.w,
                      onPressed: () async {
                        setState(() {
                          for (var userId in itemsGroupedByUser.keys) {
                            PushNotificationService.sendNotificationToUser(
                              userId,
                              "The Order You're Joined Is Placed Successfully",
                            );
                            NotificationService.saveNotification(
                                "The Order You're Joined Is Placed Successfully",
                                "We Will Wait it together",
                                userId);
                          }
                          widget.orderEntity.status = OrderStatusEnum.arrived;
                          updateOrderStatus();
                        });
                        widget.orderEntity.status = OrderStatusEnum.placed;
                        updateOrderStatus();
                        await Future.delayed(Duration(seconds: 10));
                        await assignUsersAndNotify();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewOrderPage(
                              onCalculate: onCalculatePressed,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: widget.orderEntity.status == OrderStatusEnum.active,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: itemController,
                          decoration: const InputDecoration(
                            hintText: 'Enter item',
                          ),
                          onTap: () {
                            setState(() {
                              keyboardHeight = 300;
                            });
                          },
                          onTapOutside: (value) {
                            setState(() {
                              keyboardHeight = 0;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              keyboardHeight = 0;
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            itemCount = itemCount > 0 ? itemCount - 1 : 0;
                          });
                        },
                        icon: const Icon(Icons.remove),
                        color: Colors.red,
                      ),
                      Text(
                        '$itemCount',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            itemCount++;
                          });
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: CommonElevatedButtonWidget(
                          text: 'Add',
                          onPressed: () => _addItem(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: keyboardHeight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addItem() async {
    String newItem = itemController.text.trim();
    if (newItem.isNotEmpty && itemCount > 0) {
      OrderItem orderItem = OrderItem(
        itemName: newItem,
        quantity: itemCount,
        userId: currentUser!.uid,
      );
      setState(() {
        itemsList.add(orderItem);
        itemController.clear();
        itemCount = 0;
        _handleItemAdded();
        updateOrdersAndUsers();
      });
      addOrderUsecase.update(widget.orderEntity);
    }
  }
}
