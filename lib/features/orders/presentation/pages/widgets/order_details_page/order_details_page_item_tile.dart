import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

// ignore: must_be_immutable
class EventDetailPageItemTile extends StatefulWidget {
  EventDetailPageItemTile({
    required this.userId,
    required this.items,
    required this.user,
    required this.status,
    required this.onDeleteItem,
    super.key,
    this.orderEntity,
  });

  final String userId;
  final OrderStatusEnum status;
  final List<OrderItem> items;
  final RegisterAccountModel? user;
  OrderEntity? orderEntity;
  final Function(OrderItem item) onDeleteItem;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  State<EventDetailPageItemTile> createState() =>
      _EventDetailPageItemTileState();
}

class _EventDetailPageItemTileState extends State<EventDetailPageItemTile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateItemQuantity(OrderItem item) async {
    try {
      String orderId = widget.orderEntity?.id ?? '';
      DocumentSnapshot<Map<String, dynamic>> orderDoc =
          await _firestore.collection('Order').doc(orderId).get();
      List<dynamic> items = orderDoc.get('items');
      List<Map<String, dynamic>> mappedItems =
          items.cast<Map<String, dynamic>>();
      int itemIndex = mappedItems.indexWhere((Map<String, dynamic> i) =>
          i['itemName'] == item.itemName && i['userId'] == item.userId);
      if (itemIndex != -1) {
        mappedItems[itemIndex]['quantity'] = item.quantity;

        await _firestore
            .collection('Order')
            .doc(orderId)
            .update(<Object, Object?>{
          'items': mappedItems,
        });
      }
    } catch (e) {
      print('Failed to update item quantity: $e');
    }
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
                colors: <Color>[
                  Colors.white,
                  Colors.white70,
                  Colors.blue[200]!
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
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
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              '${widget.user?.name?.toUpperCase() ?? ''} ',
                              style: TextStyles
                                  .font20BlueGradienteBoldForItemsList),
                        ),
                      ],
                    ),
                    ...widget.items.map(
                      (OrderItem item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(item.itemName,
                                  style: TextStyles
                                      .font20BlueGradienteBoldForItemsList),
                            ),
                            Expanded(
                              flex: 1,
                              child: Visibility(
                                visible: item.userId == widget.currentUser!.uid,
                                child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: Colors.blue.shade900),
                                  onPressed: () async {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      }
                                    });
                                    await _updateItemQuantity(item);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text('x ${item.quantity}',
                                    style: TextStyles
                                        .font20BlueGradienteBoldForItemsList),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Visibility(
                                visible: item.userId == widget.currentUser!.uid,
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: Colors.blue.shade900),
                                  onPressed: () async {
                                    setState(() {
                                      item.quantity++;
                                    });
                                    await _updateItemQuantity(item);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Visibility(
                                visible: item.userId == widget.currentUser!.uid,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => widget.onDeleteItem(item),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
