import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:order/core/services/notification_service.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

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
  Map<String, TextEditingController> priceControllers = {};
  Map<String, RegisterAccountModel> userMap = {};
  Map<String, double> userTotalPrices = {};
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  late AddOrderUsecase addOrderUsecase;
  late GetUserUsecase getUserUsecase;

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

  void _updateItemTotalPrice(String? userId, double? totalPrice) async {
    setState(() {
      isLoading = true;
    });
    await addOrderUsecase.update(widget.orderEntity);
    setState(() {
      isLoading = false;
    });
    PushNotificationService.sendNotificationToUser(
        userId, "Your Total Price Is  ${totalPrice?.toStringAsFixed(2) ?? ""}");
    NotificationService.saveNotification(
        "Your Total Price Is", totalPrice?.toStringAsFixed(2) ?? "");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Order prices updated successfully!'),
    ));
  }

  @override
  void dispose() {
    for (var controller in priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<OrderItem> items = widget.orderEntity.items ?? [];
    String createdAt =
        DateFormat('yyyy-MM-dd hh:mm a').format(widget.orderEntity.createdAt);

    return Scaffold(
      appBar: AppBarWidget(
        pageName: "Order ${widget.orderEntity.title} Summary",
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
                  return UserItemsTile(
                    user: userMap[userId],
                    items: userItems,
                    updateOrder: _updateItemTotalPrice,
                    orderEntity: widget.orderEntity,
                    createdAt: widget.orderEntity.createdAt, // Pass createdAt
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CommonElevatedButtonWidget(
                height: 60.h,
                text: 'Order Arrived',
                onPressed: () {
                  widget.orderEntity.status = 'Arrived';
                  widget.onCalculate!();
                  setState(() {});
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
  final RegisterAccountModel? user;
  final List<OrderItem> items;
  final OrderEntity orderEntity;
  final DateTime createdAt; // Add this line

  final Function(String? userId, double? totalPrice) updateOrder;

  const UserItemsTile({
    Key? key,
    required this.user,
    required this.items,
    required this.updateOrder,
    required this.orderEntity,
    required this.createdAt,
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
  double? totalPrice;

  @override
  initState() {
    super.initState();
    itemsList = widget.orderEntity.items ?? [];
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in widget.items) {
      total += item.totalPrice ?? 0;
    }
    // Apply VAT (14%)
    double totalWithVAT = total * 1.14;
    return totalWithVAT;
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
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromRGBO(72, 129, 255, 0.06),
                              radius: 50,
                              backgroundImage:
                                  '${widget.user?.profileImageUrl}'.isNotEmpty
                                      ? NetworkImage(
                                          '${widget.user?.profileImageUrl}')
                                      : null,
                              child: '${widget.user?.profileImageUrl}'.isEmpty
                                  ? const Icon(Icons.add_a_photo,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('${widget.user?.name}',
                                      style: TextStyles.font20WhiteBold),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...widget.items
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(item.itemName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.font18WhiteBold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${item.quantity}x',
                                      style: TextStyles.font18WhiteBold,
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 120,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              onChanged: (String price) {
                                                setState(() {
                                                  item.price =
                                                      double.tryParse(price);
                                                  item.totalPrice =
                                                      (item.price ?? 0.0) *
                                                          item.quantity;
                                                });
                                              },
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    4),
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Price',
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minWidth: 60),
                                    child: Text('${item.totalPrice ?? ""}',
                                        style: TextStyles.font18WhiteBold),
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
                              totalPrice = calculateTotalPrice();
                              widget.updateOrder(
                                  widget.user?.userId, totalPrice);
                              PushNotificationService.sendNotificationToUser(
                                  widget.user?.userId,
                                  "Your Total Price Is ${totalPrice?.toStringAsFixed(2)}");
                              NotificationService.saveNotification(
                                  "Your Total Price Is",
                                  '${totalPrice?.toStringAsFixed(2)}');
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Created At: ${DateFormat('yyyy-MM-dd hh:mm a').format(widget.createdAt)}",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Total (including VAT 14%): ${totalPrice?.toStringAsFixed(2) ?? ""} L.E",
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
