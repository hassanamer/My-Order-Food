import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:order/core/services/notification_service.dart';
import 'package:order/core/services/push_notification_service.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/cart/presentation/pages/view_order_page.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/remote_usecases/add_order_usecase.dart';
import 'package:order/features/event/domain/remote_usecases/remote_get_user_order.dart';
import 'package:order/features/event/presentation/pages/widgets/order_details_page/order_details_page_item_tile.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/injection_container.dart';

// ignore: must_be_immutable
class OrderDetailsBody extends StatefulWidget {
  final OrderEntity orderEntity;
  Map<String, List<OrderItem>> itemsGroupedByUser;
  late Future<Map<String, RegisterAccountModel>> userMapFuture;
  final Future<void>? addItem;
  bool isCreator = false;
  final VoidCallback? onCalculatePressed;
  final String itemName;
  final Function(String) setItemName;
  final int itemCount;
  final Function(int) setItemCount;
  final TextEditingController itemController;
  List<OrderItem> itemsList;

  OrderDetailsBody(
      {required this.orderEntity,
      required this.itemsGroupedByUser,
      required this.userMapFuture,
      required this.isCreator,
      required this.itemName,
      required this.setItemName,
      required this.itemCount,
      required this.setItemCount,
      required this.itemController,
      required this.itemsList,
      super.key,
      this.addItem,
      this.onCalculatePressed});

  @override
  State<OrderDetailsBody> createState() => _OrderDetailsBodyState();
}

class _OrderDetailsBodyState extends State<OrderDetailsBody>
    with WidgetsBindingObserver {
  late GetUserUsecase getUserOrderUsecase;
  late AddOrderUsecase addOrderUsecase;
  late String createdAt;
  User? currentUser = FirebaseAuth.instance.currentUser;
  RegisterAccountModel? placer;
  RegisterAccountModel? receiver;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double keyboardHeight = 0;
  bool isKeyboardOpen = false; // New variable

  updateOrderStatus() {
    addOrderUsecase.updateOrderStatus(
        widget.orderEntity.id, widget.orderEntity.status);
  }

  Future<void> addItem(String itemName, int itemCount) async {
    if (itemName.isNotEmpty && itemCount > 0) {
      OrderItem orderItem = OrderItem(
        itemName: itemName,
        quantity: itemCount,
        userId: currentUser!.uid,
      );
      widget.orderEntity.items?.add(orderItem);
      // Clear the text field and reset itemCount
      widget.setItemName('');
      widget.setItemCount(0);
      addOrderUsecase.update(widget.orderEntity);
      //
      setState(() {
        widget.itemsList.add(orderItem);
        // itemController.clear();
        // itemCount = 0;
        // _handleItemAdded();
        // updateOrdersAndUsers();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    addOrderUsecase = sl();
    getUserOrderUsecase = sl();
    // ignore: unnecessary_null_comparison
    createdAt = widget.orderEntity.createdAt != null
        ? DateFormat('yyyy-MM-dd hh:mm a').format(widget.orderEntity.createdAt)
        : 'Unknown';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final ViewPadding viewInsets =
        WidgetsBinding.instance.platformDispatcher.views.first.viewInsets;
    setState(() {
      keyboardHeight = viewInsets.bottom;
    });
  }

  Future<void> assignUsersAndNotify(
      Map<String, RegisterAccountModel> userMap) async {
    List<RegisterAccountModel> usersInOrder = userMap.values.toList();
    usersInOrder.sort((RegisterAccountModel a, RegisterAccountModel b) =>
        a.placedOrderCount!.compareTo(b.placedOrderCount!));

    placer = null;
    receiver = null;

    for (RegisterAccountModel user in usersInOrder) {
      if (placer == null &&
          (user.deliveryPreference == 'Place the order' ||
              user.hasCar == 'No')) {
        placer = user;
        widget.orderEntity.placerUid = placer!.userId;
      }
      if (placer != null) {
        break;
      }
    }

    if (placer == null && usersInOrder.isNotEmpty) {
      placer = usersInOrder.first;
      widget.orderEntity.placerUid = placer!.userId;
    }

    for (RegisterAccountModel user in usersInOrder) {
      if (receiver == null &&
          (user.hasCar == 'Yes' ||
              user.deliveryPreference == 'Receive it at the gate')) {
        receiver = user;
        widget.orderEntity.receiverUid = receiver!.userId;
      }
      if (receiver != null) {
        break;
      }
    }

    if (receiver == null && usersInOrder.isNotEmpty) {
      usersInOrder.sort((RegisterAccountModel a, RegisterAccountModel b) =>
          a.receivedOrderCount!.compareTo(b.receivedOrderCount!));
      receiver = usersInOrder.firstWhere(
          (RegisterAccountModel user) => user.userId != placer?.userId,
          orElse: () => usersInOrder.first);
      if (receiver != null) {
        widget.orderEntity.receiverUid = receiver!.userId;
      }
    }
    if (placer != null) {
      await placer!.incrementPlacedOrderCount();
      await _firestore
          .collection('Users')
          .doc(placer!.userId)
          .update(placer!.toMap());
      PushNotificationService.sendNotificationToUser(placer!.userId,
          "You're Chosen To Place The Order, Thank You So Much For Your Help");
      NotificationService.saveNotification("You're Chosen To Place The Order",
          'Thank You So Much For Your Help', placer!.userId);
    }

    if (receiver != null) {
      await receiver!.incrementReceivedOrderCount();
      await _firestore
          .collection('Users')
          .doc(receiver!.userId)
          .update(receiver!.toMap());
      PushNotificationService.sendNotificationToUser(receiver!.userId,
          "You're Chosen To Receive The Order At The Gate, Thank You So Much For Your Help");
      NotificationService.saveNotification(
          "You're Chosen To Receive The Order At The Gate",
          'Thank You So Much For Your Help',
          receiver!.userId);
    }

    await addOrderUsecase.update(widget.orderEntity);

    await _firestore
        .collection('Order')
        .doc(widget.orderEntity.id)
        .update(<Object, Object?>{
      'placerUid': placer?.userId,
      'receiverUid': receiver?.userId,
    });

    setState(() {});
  }

  Future<void> _deleteItem(OrderItem item) async {
    if (item.userId == currentUser!.uid) {
      try {
        final DocumentReference<Map<String, dynamic>> orderDoc =
            _firestore.collection('Order').doc(widget.orderEntity.id);
        final DocumentSnapshot<Map<String, dynamic>> orderSnapshot =
            await orderDoc.get();
        final List<Map<String, dynamic>> items =
            List<Map<String, dynamic>>.from(orderSnapshot.get('items'));
        final int itemIndex = items.indexWhere((Map<String, dynamic> i) =>
            i['itemName'] == item.itemName && i['userId'] == item.userId);
        if (itemIndex != -1) {
          items.removeAt(itemIndex);
          await orderDoc.update(<Object, Object?>{
            'items': items,
          });
        }
      } catch (e) {
        print('Failed to delete item: $e');
      }

      setState(() {
        widget.itemsList.remove(item);
        widget.itemsGroupedByUser[item.userId]?.remove(item);
        if (widget.itemsGroupedByUser[item.userId]?.isEmpty ?? false) {
          widget.itemsGroupedByUser.remove(item.userId);
        }
      });
    } else {
      print('You can only delete your own items.');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserPlacerOrReceiver = currentUser != null &&
        (currentUser!.uid == placer?.userId ||
            currentUser!.uid == receiver?.userId);

    const Divider divider = Divider(
      thickness: 1,
      height: 3,
    );
    return FutureBuilder<Map<String, RegisterAccountModel>>(
        future: widget.userMapFuture,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, RegisterAccountModel>> userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          if (!userSnapshot.hasData) {
            return const LoadingWidget();
          }

          Map<String, RegisterAccountModel> userMap = userSnapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Created At : $createdAt',
                          style: TextStyles.font18WhiteBold,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                const TextSpan(
                                  text: 'Status : ',
                                  style: TextStyles.font18WhiteBold,
                                ),
                                TextSpan(
                                  text: widget.orderEntity.status.name,
                                  style: TextStyles.font18WhiteBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.itemsGroupedByUser.length,
                    itemBuilder: (BuildContext context, int index) {
                      String userId =
                          widget.itemsGroupedByUser.keys.elementAt(index);
                      List<OrderItem> userItems =
                          widget.itemsGroupedByUser[userId]!;
                      return EventDetailPageItemTile(
                        userId: userId,
                        orderEntity: widget.orderEntity,
                        items: userItems,
                        user: userMap[userId],
                        status: widget.orderEntity.status,
                        onDeleteItem: (OrderItem item) => _deleteItem(item),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        divider,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    Visibility(
                      visible:
                          widget.orderEntity.status == OrderStatusEnum.active,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: widget.itemController,
                              decoration: const InputDecoration(
                                labelText: 'Add Item',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: widget.setItemName,
                              onTap: () {
                                setState(() {
                                  keyboardHeight = 310;
                                });
                              },
                              onTapOutside: (PointerDownEvent value) {
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
                              // setState(() {
                              widget.setItemCount(widget.itemCount > 0
                                  ? widget.itemCount - 1
                                  : 0); // });
                            },
                            icon: const Icon(Icons.remove),
                            color: Colors.red,
                          ),
                          Text(
                            '${widget.itemCount}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            onPressed: () {
                              // setState(() {
                              widget.setItemCount(widget.itemCount + 1); // });
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            child: CommonElevatedButtonWidget(
                                text: 'Add',
                                onPressed: () async {
                                  await addItem(
                                      widget.itemName, widget.itemCount);
                                  if (widget.itemController.text.isNotEmpty) {
                                    setState(() {
                                      widget.itemController.clear();
                                    });
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: widget.orderEntity.status ==
                                OrderStatusEnum.active &&
                            (widget.isCreator || isCurrentUserPlacerOrReceiver),
                        child: CommonElevatedButtonWidget(
                          text: 'Place Your Order...',
                          width: 100.w,
                          onPressed: () async {
                            setState(() {
                              for (String userId
                                  in widget.itemsGroupedByUser.keys) {
                                PushNotificationService.sendNotificationToUser(
                                  userId,
                                  "The Order You're Joined Is Placed Successfully",
                                );
                                NotificationService.saveNotification(
                                    "The Order You're Joined Is Placed Successfully",
                                    'We Will Wait it together',
                                    userId);
                                widget.orderEntity.status =
                                    OrderStatusEnum.placed;
                              }
                            });
                            updateOrderStatus();
                            // ignore: always_specify_types
                            await Future.delayed(const Duration(seconds: 10));
                            await assignUsersAndNotify(
                                await widget.userMapFuture);
                            await Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    ViewOrderPage(
                                  onCalculate: widget.onCalculatePressed,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: keyboardHeight,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
