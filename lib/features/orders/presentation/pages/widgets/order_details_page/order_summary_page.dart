import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/notification/data/datasources/push_notification_service.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_add_order_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_user_order.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_details_page/user_items_tile.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/injection_container.dart';

// ignore: must_be_immutable
class OrderSummaryPage extends StatefulWidget {
  Map<String, double> itemTotalPrices = <String, double>{};
  final VoidCallback? onCalculate;

  final String orderId;
  final OrderEntity orderEntity;

  OrderSummaryPage({
    required this.orderId,
    required this.orderEntity,
    super.key,
    this.onCalculate,
  });

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  bool isLoading = true;
  Map<String, RegisterAccountModel> userMap = <String, RegisterAccountModel>{};
  Map<String, double> itemsTotalPricePerUser = <String, double>{};
  Map<String, List<OrderItem>> itemsGroupedByUser = <String, List<OrderItem>>{};
  late AddOrderUsecase addOrderUsecase;
  late GetUserUsecase getUserUsecase;
  double userDeliveryFee = 0.0;
  double vat = 0;
  double? deliveryFee;
  double keyboardHeight = 0;
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isCreator = false;
  late OrderCubit orderCubit;
  late Stream<OrderEntity> orderStream;

  updateOrderStatus() {
    addOrderUsecase.updateOrderStatus(
        widget.orderEntity.id, widget.orderEntity.status);
  }

  @override
  void initState() {
    super.initState();
    addOrderUsecase = sl();
    getUserUsecase = sl();
    _intializeItemsGroupedByUser();
    getUserUsecase
        .getUsers(itemsGroupedByUser.keys.toList())
        .then((Map<String, RegisterAccountModel> value) => setState(() {
              userMap = value;
              isLoading = false;
            }));
    deliveryFee = widget.orderEntity.deliveryFees;
    userDeliveryFee =
        widget.orderEntity.deliveryFees ?? 0 / itemsGroupedByUser.length;
    vat = widget.orderEntity.vat;
    isCreator = currentUser?.uid == widget.orderEntity.userId;
    orderCubit = context.read<OrderCubit>();
    orderStream = orderCubit.getOrderStream(widget.orderId);
  }

  void _intializeItemsGroupedByUser() {
    List<OrderItem> items = widget.orderEntity.items ?? <OrderItem>[];

    for (OrderItem item in items) {
      String userId = item.userId;
      if (!itemsGroupedByUser.containsKey(userId)) {
        itemsGroupedByUser[userId] = <OrderItem>[];
      }
      itemsGroupedByUser[userId]!.add(item);
    }
  }

  void _updateOrder() async {
    setState(() {
      isLoading = true;
    });
    widget.orderEntity.deliveryFees = userDeliveryFee;
    widget.orderEntity.vat = vat;
    await addOrderUsecase.update(widget.orderEntity);
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Order prices updated successfully!'),
    ));
  }

  void _onCheckBoxChanged(bool? value) {
    setState(() {
      if (value == true) {
        vat = 0.14;
      } else {
        vat = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
          child: const Center(child: LoadingWidget()));
    }
    return StreamBuilder<OrderEntity>(
        stream: orderStream,
        builder: (BuildContext context, AsyncSnapshot<OrderEntity> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: <Widget>[
                Container(
                  color: Colors.white.withOpacity(0.9),
                  child: const LoadingWidget(),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No Order Data'));
          }

          OrderEntity orderEntity = snapshot.data!;
          bool isCurrentUserPlacerOrReceiver = currentUser != null &&
              (currentUser!.uid == orderEntity.placerUid ||
                  currentUser!.uid == orderEntity.receiverUid ||
                  currentUser!.uid == orderEntity.userId);

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBarWidget(
              pageName: 'Order ${widget.orderEntity.title} Summary',
              pageDescreption:
                  "Created At: ${DateFormat('yyyy-MM-dd hh:mm a').format(widget.orderEntity.createdAt)}",
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: itemsGroupedByUser.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        String userId =
                            itemsGroupedByUser.keys.elementAt(index);
                        List<OrderItem> userItems = itemsGroupedByUser[userId]!;
                        return UserItemsTile(
                          isCurrentUserPlacerOrReceiver:
                              isCurrentUserPlacerOrReceiver,
                          user: userMap[userId]!,
                          items: userItems,
                          updateOrder: _updateOrder,
                          orderEntity: widget.orderEntity,
                          createdAt: widget.orderEntity.createdAt,
                          userDeliveryFee: userDeliveryFee,
                          vat: vat,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: (isCurrentUserPlacerOrReceiver),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '${deliveryFee ?? 'Delivery Fees'}',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                        hintText: "${deliveryFee ?? 'Delivery Fees'}",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          deliveryFee = double.tryParse(value) ?? 0.0;
                          if (itemsGroupedByUser.isNotEmpty) {
                            userDeliveryFee = (deliveryFee ?? 0.0) /
                                (itemsGroupedByUser.length.toDouble());
                          } else {
                            userDeliveryFee = 0.0;
                          }
                        });
                      },
                      onTap: () {
                        setState(() {
                          keyboardHeight = 300;
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
                  const SizedBox(height: 20),
                  Visibility(
                    visible: (isCurrentUserPlacerOrReceiver),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              value: vat != 0, onChanged: _onCheckBoxChanged),
                          const Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            'Including VAT 14 %',
                            style: TextStyles.font14WhiteMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (isCurrentUserPlacerOrReceiver),
                    child: Center(
                      child: CommonElevatedButtonWidget(
                        height: 60.h,
                        text: 'Order Arrived',
                        onPressed: () {
                          setState(() {
                            for (String userId in itemsGroupedByUser.keys) {
                              PushNotificationService.sendNotificationToUser(
                                userId,
                                'Your Order Is Arrived, Hurry Up, We Waiting You',
                              );
                              PushNotificationService.saveNotification(
                                  'Your Order Is Arrived',
                                  'Your Order Is Arrived, Hurry Up, We Waiting You',
                                  userId);
                            }
                            widget.orderEntity.status = OrderStatusEnum.arrived;
                            updateOrderStatus();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: keyboardHeight,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
