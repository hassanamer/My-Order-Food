import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/cart/presentation/pages/view_order_page.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/remote_usecases/add_order_usecase.dart';
import 'package:order/features/event/domain/remote_usecases/remote_get_user_order.dart';
import 'package:order/features/event/presentation/pages/widgets/order_details_page/order_details_page_item_tile.dart';
import 'package:order/injection_container.dart';

import '../../../../../../core/services/awesome_notification_service.dart';
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

  User? currentUser = FirebaseAuth.instance.currentUser;

  List<OrderItem> itemsList = [];
  TextEditingController itemController = TextEditingController();
  int itemCount = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  Map<String, RegisterAccountModel> userMap = {};
  bool isLoading = true;

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
  }

  refreshOrder() async {
    widget.orderEntity =
        await addOrderUsecase.remoteGetOrder(widget.orderEntity.id);
    updateOrdersAndUsers();
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    const divider = Divider(
      thickness: 1,
      height: 3,
    );

    return Scaffold(
      appBar: AppBarWidget(
        pageName: widget.orderEntity.title ?? '',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    items: userItems,
                    user: userMap[userId],
                  );
                },
                separatorBuilder: (context, index) => divider,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await AwesomeNotificationService.showNotification(
                      title: "Order Placed Successfully",
                      body:
                          'Order That You\'re Joined Is Placed successfully, When It Arrive You Will Notified');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewOrderPage(),
                    ),
                  );

                  setState(() {
                    refreshOrder();
                  });
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
                  'Place Your Order...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemController,
                    decoration: const InputDecoration(
                      hintText: 'Enter item',
                    ),
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
                  child: ElevatedButton(
                    onPressed: () => _addItem(),
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
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
      // Optimistically update the UI
      setState(() {
        itemsList.add(orderItem);
        itemController.clear();
        itemCount = 0;
        updateOrdersAndUsers();
      });
      addOrderUsecase.update(widget.orderEntity);
      // Update Firestore in the background
      //   orderDocRef.get().then((docSnapshot) {
      //     if (docSnapshot.exists) {
      //       Map<String, dynamic> data = docSnapshot.data()!;
      //       if (data['items'] == null) {
      //         data['items'] = [];
      //       }
      //       data['items'].add({
      //         'itemName': newItem,
      //         'quantity': itemCount,
      //         'userId': currentUser!.uid,
      //       });
      //       orderDocRef.update(data);
      //     } else {
      //       orderDocRef.set({
      //         'items': [
      //           {
      //             'itemName': newItem,
      //             'quantity': itemCount,
      //             'userId': currentUser!.uid
      //           }
      //         ],
      //       });
      //     }
      //   });
    }
  }

  Future<void> _updateOrder() async {
    addOrderUsecase.update(widget.orderEntity);
  }
}
