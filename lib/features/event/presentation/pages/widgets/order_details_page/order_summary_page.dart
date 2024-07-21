import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

import '../../../../../../injection_container.dart';
import '../../../../../register/data/models/register_account_model.dart';
import '../../../../domain/remote_usecases/add_order_usecase.dart';
import '../../../../domain/remote_usecases/remote_get_user_order.dart';

class OrderSummaryPage extends StatefulWidget {
  Map<String, double> itemTotalPrices = {};
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
  var isLoading = true;
  Map<String, TextEditingController> priceControllers = {};

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

  void _updateItemTotalPrice() async {
    setState(() {
      isLoading = true;
    });

    await widget.addOrderUsecase.updatePrice(widget.orderEntity);
    // _updateUserTotalPrices();
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Order prices updated successfully!'),
    ));
  }

  // void _updateUserTotalPrices() {
  //   userTotalPrices.clear();
  //   Map<String, double> tempUserTotals = {};
  //
  //   widget.orderEntity.items?.forEach((item) {
  //     String userId = item.userId;
  //     double itemTotal = itemTotalPrices[item.itemName] ?? 0.0;
  //
  //     if (tempUserTotals.containsKey(userId)) {
  //       tempUserTotals[userId] = tempUserTotals[userId]! + itemTotal;
  //     } else {
  //       tempUserTotals[userId] = itemTotal;
  //     }
  //   });
  //
  //   setState(() {
  //     userTotalPrices = tempUserTotals;
  //   });
  // }

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
                    itemTotalPrice: widget.itemTotalPrices,
                    updateOrderPrices: _updateItemTotalPrice,
                    orderEntity: widget.orderEntity,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class UserItemsTile extends StatefulWidget {
  final String userId;
  final List<OrderItem> items;
  final OrderEntity orderEntity;

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
    required this.orderEntity,
  }) : super(key: key);

  @override
  _UserItemsTileState createState() => _UserItemsTileState();
}

class _UserItemsTileState extends State<UserItemsTile> {
  late GetUserOrderUsecase getUserOrderUsecase;

  double calculateTotalPrice() {
    double total = 0.0;
    widget.itemTotalPrice.values.forEach((price) {
      total += price;
    });
    return total * 1.14;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  Map<String, RegisterAccountModel> userMap = {};
  List<OrderItem> itemsList = [];
  bool isLoading = true;

  updateOrdersAndUsers() {
    userMap = {};
    itemsGroupedByUser = {};
    for (var item in itemsList) {
      itemsGroupedByUser.putIfAbsent(item.userId, () => []).add(item);
    }
    getUsers(itemsGroupedByUser).then((userMap) {
      setState(() {
        this.userMap = userMap;
        isLoading = false;
      });
    });
  }

  @override
  initState() {
    super.initState();
    itemsList = widget.orderEntity.items ?? [];
    updateOrdersAndUsers();
  }

  Future<Map<String, RegisterAccountModel>> getUsers(
      Map<String, List<OrderItem>> itemsGroupedByUser) async {
    getUserOrderUsecase = sl();

    Map<String, RegisterAccountModel> userMap = {};

    List<Future<void>> futures = [];

    for (var entry in itemsGroupedByUser.entries) {
      String userId = entry.key;
      futures.add(getUserOrderUsecase.call(userId).then((user) {
        userMap[userId] = user;
      }));
    }

    await Future.wait(futures);

    return userMap;
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
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'User: ${widget.user?.name}',
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
                                    item.itemName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'X: ${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onSubmitted: (String price) {
                                              setState(() {
                                                item.price =
                                                    double.tryParse(price);
                                                item.totalPrice =
                                                    (item.price ?? 0.0) *
                                                        item.quantity;
                                              });
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
                                ],
                              ),
                            ))
                        .toList(),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.updateOrderPrices();
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
                          'Calculate The Total Price...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Column(
                      children: [
                        // Text(
                        //   //$createdAt
                        //   "Created At: ",
                        //   style: TextStyle(color: Colors.white, fontSize: 16),
                        // ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            //${calculateTotalPrice()
                            "Total (including VAT 14%): } 0.0 L.E",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
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
