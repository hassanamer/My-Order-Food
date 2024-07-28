import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

import '../../../../../../core/services/push_notification_service.dart';
import '../../../../../../injection_container.dart';
import '../../../../../register/data/models/register_account_model.dart';
import '../../../../domain/remote_usecases/add_order_usecase.dart';
import '../../../../domain/remote_usecases/remote_get_user_order.dart';

class OrderSummaryPage extends StatefulWidget {
  Map<String, double> itemTotalPrices = {};
  final VoidCallback? onCalculate;

  final String orderId;
  final OrderEntity orderEntity;
  late AddOrderUsecase addOrderUsecase;
  late GetUserUsecase getUserUsecase;

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

  @override
  void initState() {
    super.initState();
    widget.addOrderUsecase = sl();
    widget.getUserUsecase = sl();
    // _initializePriceControllers();
    _intializeItemsGroupedByUser();
    widget.getUserUsecase
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

  // void _initializePriceControllers() {
  //   for (var item in items) {
  //     String itemId = item['itemName'] ?? '';
  //     priceControllers[itemId] = TextEditingController();
  //     priceControllers[itemId]!.text = item['price']?.toString() ?? '';
  //     priceControllers[itemId]!.addListener(
  //         () => _updateItemTotalPrice(itemId, item['quantity'] ?? 1));
  //   }
  // }

  void _updateItemTotalPrice(String? userId, double? totalPrice) async {
    setState(() {
      isLoading = true;
    });

    await widget.addOrderUsecase.update(widget.orderEntity);
    // _updateUserTotalPrices();
    setState(() {
      isLoading = false;
    });
    // Send notification to the user with their total price
    PushNotificationService.sendNotificationToUser(
        userId, "Your Total Price Is  ${totalPrice?.toStringAsFixed(2) ?? ""}");
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
    String createdAt = widget.orderEntity.createdAt != null
        ? DateFormat('yyyy-MM-dd hh:mm a')
            .format((widget.orderEntity.createdAt as Timestamp).toDate())
        : 'Unknown';

    return Scaffold(
      appBar: AppBarWidget(
        pageName: "Order #${widget.orderId} Summary",
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
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onCalculate!();
                  setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.blue;
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(5),
                  shadowColor: MaterialStateProperty.all<Color>(
                    Colors.grey.withOpacity(0.5),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(15),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 18),
                  ),
                ),
                child: const Text(
                  'Order Arrived',
                  style: TextStyle(color: Colors.white),
                ),
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

//  final Map<String, TextEditingController> priceControllers;
//   final Map<String, double> itemTotalPrice;
  final Function(String? userId, double? totalPrice) updateOrder;

  const UserItemsTile({
    Key? key,
    required this.user,
    required this.items,
    // required this.itemTotalPrice,
    required this.updateOrder,
    required this.orderEntity,
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
                                  Text(
                                    '${widget.user?.name}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: Colors.white),
                                  ),
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
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.itemName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${item.quantity}x',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minWidth: 60),
                                    child: Text(
                                      '${item.totalPrice ?? ""}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            totalPrice = calculateTotalPrice();
                            widget.updateOrder(widget.user?.userId, totalPrice);
                            // Send notification to the user
                            PushNotificationService.sendNotificationToUser(
                                widget.user?.userId,
                                totalPrice?.toStringAsFixed(2));
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              }
                              return Colors.blue;
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(5),
                          shadowColor: MaterialStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.5),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(15),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(fontSize: 18),
                          ),
                        ),
                        child: const Text(
                          'Calculate Total Price',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        // Text(
                        //   //$createdAt
                        //   "Created At: ",
                        //   style: TextStyle(color: Colors.white, fontSize: 16),
                        // ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Total (including VAT 14%): ${totalPrice?.toStringAsFixed(2) ?? ""} L.E",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
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
