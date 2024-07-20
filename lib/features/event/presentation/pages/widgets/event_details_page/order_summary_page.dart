import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

import '../../../../../../injection_container.dart';
import '../../../../../register/data/models/register_account_model.dart';
import '../../../../domain/remote_usecases/add_order_usecase.dart';

class OrderSummaryPage extends StatefulWidget {
  final String orderId;
  final OrderEntity orderEntity;
  late AddOrderUsecase addOrderUsecase;

  OrderSummaryPage({
    Key? key,
    required this.orderId,
    required this.orderEntity,
  }) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  Map<String, TextEditingController> priceControllers = {};
  Map<String, double> itemTotalPrices = {};
  Map<String, double> userTotalPrices = {};
  Map<String, List<OrderItem>> itemsGroupedByUser = {};

  @override
  void initState() {
    super.initState();
    widget.addOrderUsecase = sl();
    // _initializePriceControllers();
    _intializeItemsGroupedByUser();
  }

  void _intializeItemsGroupedByUser() {
    List<OrderItem> items = widget.orderEntity.items ?? [];

    for (var item in items) {
      String userId = item.userId ?? 'Unknown';
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

  void _updateItemTotalPrice() {
    widget.addOrderUsecase.update(widget.orderEntity);
    // _updateUserTotalPrices();
  }

  void _updateUserTotalPrices() {
    userTotalPrices.clear();
    Map<String, double> tempUserTotals = {};

    widget.orderEntity.items?.forEach((item) {
      String userId = item.userId ?? 'Unknown';
      double itemTotal = itemTotalPrices[item.itemName] ?? 0.0;

      if (tempUserTotals.containsKey(userId)) {
        tempUserTotals[userId] = tempUserTotals[userId]! + itemTotal;
      } else {
        tempUserTotals[userId] = itemTotal;
      }
    });

    setState(() {
      userTotalPrices = tempUserTotals;
    });
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
            const Text(
              "Items:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: itemsGroupedByUser.keys.length,
                itemBuilder: (context, index) {
                  String userId = itemsGroupedByUser.keys.elementAt(index);
                  List<OrderItem> userItems = itemsGroupedByUser[userId]!;
                  return UserItemsTile(
                    userId: userId,
                    items: userItems,
                    itemTotalPrice: itemTotalPrices,
                    updateOrderPrices: _updateItemTotalPrice,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Created At: $createdAt",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Total (including VAT 14%): ${calculateTotalPrice().toStringAsFixed(2)} L.E',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    itemTotalPrices.values.forEach((price) {
      total += price;
    });
    return total * 1.14;
  }
}

class UserItemsTile extends StatefulWidget {
  final String userId;
  final List<OrderItem> items;

//  final Map<String, TextEditingController> priceControllers;
  final Map<String, double> itemTotalPrice;
  final Function() updateOrderPrices;
  final RegisterAccountModel? user;

  const UserItemsTile({
    Key? key,
    required this.userId,
    required this.items,
    // required this.priceControllers,
    required this.itemTotalPrice,
    required this.updateOrderPrices,
    this.user,
  }) : super(key: key);

  @override
  _UserItemsTileState createState() => _UserItemsTileState();
}

class _UserItemsTileState extends State<UserItemsTile> {
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
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'User: ${widget.userId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                                  Text(
                                    item.itemName ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item.quantity ?? 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onSubmitted: (String price) {
                                              item.price =
                                                  double.tryParse(price);
                                              item.totalPrice = item.price ??
                                                  0.0 * item.quantity;
                                            },
                                            keyboardType: TextInputType.number,
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
                                  Text(
                                    'Total: ${(widget.itemTotalPrice[item.itemName] ?? 0).toStringAsFixed(2)} L.E',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    const SizedBox(height: 10),
                    IconButton(
                      icon: const Icon(Icons.calculate, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          widget.updateOrderPrices();
                        }); // Trigger rebuild
                      },
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
