import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:order/core/services/notification_service.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/register/user/pages/user_profile_screen.dart';

import '../../../../../../core/services/push_notification_service.dart';
import '../../../../../../core/widgets/common_elevated_button_widget.dart';
import '../../../../../../injection_container.dart';
import '../../../../../register/data/models/register_account_model.dart';
import '../../../../domain/remote_usecases/add_order_usecase.dart';
import '../../../../domain/remote_usecases/remote_get_user_order.dart';

class OrderSummaryPage extends StatefulWidget {
  Map<String, double> itemTotalPrices = {};
  final VoidCallback? onCalculate;

  final String orderId;
  final OrderEntity orderEntity;

  OrderSummaryPage({
    Key? key,
    required this.orderId,
    required this.orderEntity,
    this.onCalculate,
  }) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  var isLoading = true;
  TextEditingController deliveryFeesController = TextEditingController();
  Map<String, RegisterAccountModel> userMap = {};
  Map<String, double> userTotalPrices = {};
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  late AddOrderUsecase addOrderUsecase;
  late GetUserUsecase getUserUsecase;
  double deliveryFee = 0.0;

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
        .then((value) => setState(() {
              userMap = value;
            }));
  }

  void _intializeItemsGroupedByUser() {
    List<OrderItem> items = widget.orderEntity.items ?? [];

    for (var item in items) {
      String userId = item.userId;
      if (!itemsGroupedByUser.containsKey(userId)) {
        itemsGroupedByUser[userId] = [];
      }
      itemsGroupedByUser[userId]!.add(item);
    }
  }

  void _updateOrder() async {
    setState(() {
      isLoading = true;
    });

    await addOrderUsecase.update(widget.orderEntity);
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Order prices updated successfully!'),
    ));
  }

  @override
  void dispose() {
    deliveryFeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        pageName: "Order ${widget.orderEntity.title} Summary",
        pageDescreption:
            "Created At: ${DateFormat('yyyy-MM-dd hh:mm a').format(widget.orderEntity.createdAt)}",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: itemsGroupedByUser.keys.length,
                itemBuilder: (context, index) {
                  String userId = itemsGroupedByUser.keys.elementAt(index);
                  List<OrderItem> userItems = itemsGroupedByUser[userId]!;
                  double userDeliveryFee =
                      deliveryFee / itemsGroupedByUser.length;
                  return UserItemsTile(
                    user: userMap[userId]!,
                    items: userItems,
                    updateOrder: _updateOrder,
                    orderEntity: widget.orderEntity,
                    createdAt: widget.orderEntity.createdAt,
                    userDeliveryFee: userDeliveryFee,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: deliveryFeesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Delivery Fees',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  deliveryFee = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: CommonElevatedButtonWidget(
                height: 60.h,
                text: 'Order Arrived',
                onPressed: () {
                  setState(() {
                    widget.orderEntity.status = OrderStatusEnum.arrived;
                    updateOrderStatus();
                    PushNotificationService.sendNotificationToUser(
                        widget.orderEntity.userId,
                        "Your Order Is Arrived, Hurry Up, We Waiting You");
                    NotificationService.saveNotification(
                        "Your Order Is Arrived", ' Hurry Up, We Waiting You');
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserItemsTile extends StatefulWidget {
  final RegisterAccountModel user;
  final List<OrderItem> items;
  final OrderEntity orderEntity;
  final DateTime createdAt;
  final double userDeliveryFee;

  final Function() updateOrder;

  const UserItemsTile({
    Key? key,
    required this.user,
    required this.items,
    required this.updateOrder,
    required this.orderEntity,
    required this.createdAt,
    required this.userDeliveryFee,
  }) : super(key: key);

  @override
  _UserItemsTileState createState() => _UserItemsTileState();
}

class _UserItemsTileState extends State<UserItemsTile> {
  late GetUserUsecase getUserOrderUsecase;
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  Map<String, RegisterAccountModel> userMap = {};
  List<OrderItem> itemsList = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    itemsList = widget.orderEntity.items ?? [];
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in widget.items) {
      total += item.itemsTotalPrice ?? 0;
    }
    double totalWithVAT = total * 1.14;
    return totalWithVAT + widget.userDeliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 9,
                              color: Colors.transparent,
                            )
                          ],
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientCircleAvatar(
                                profileImageUrl: widget.user?.profileImageUrl,
                                width: 100.w,
                                height: 100.h),
                            const SizedBox(width: 20),
                            Text('${widget.user?.name!.toUpperCase()}',
                                style: TextStyles.font20WhiteBold),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                    ...widget.items
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(item.itemName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.font20WhiteBold),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        child: Text(
                                          '${item.quantity}x',
                                          style: TextStyles.font20WhiteBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (String price) {
                                            setState(() {
                                              item.price =
                                                  double.tryParse(price);
                                              item.itemsTotalPrice =
                                                  (item.price ?? 0.0) *
                                                      item.quantity;
                                            });
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText:
                                                '${item.price ?? 'Price'}',
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 60),
                                          child: Text(
                                              '${item.itemsTotalPrice ?? ""}',
                                              style:
                                                  TextStyles.font20WhiteBold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    const SizedBox(height: 10),
                    Center(
                      child: CommonElevatedButtonWidget(
                        width: 280.w,
                        text: 'Calculate Total Price',
                        onPressed: () {
                          setState(
                            () {
                              double userTotalPrice = calculateTotalPrice();
                              widget.orderEntity
                                      .userTotalPrices[widget.user.userId!] =
                                  userTotalPrice;
                              widget.updateOrder();
                              PushNotificationService.sendNotificationToUser(
                                  widget.user.userId,
                                  "Your Total Price Is ${userTotalPrice == 0 ? '' : userTotalPrice.toStringAsFixed(2)}");

                              NotificationService.saveNotification(
                                  "Your Total Price Is",
                                  '${userTotalPrice.toStringAsFixed(2)}');
                            },
                          );
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Total (including VAT 14%): ${widget.orderEntity.userTotalPrices[widget.user.userId!]?.toStringAsFixed(2) ?? ""} L.E",
                            style: TextStyles.font18WhiteBold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
