import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import the intl package for date formatting
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/cart/presentation/pages/view_order_page.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/event_details_page/evebt_details_page_placeholder.dart';
import '../../../cubit/ticket_cubit.dart';

class EventDetailsPage extends StatefulWidget {
  final EventEntity eventEntity;

  const EventDetailsPage({
    Key? key,
    required this.eventEntity,
  }) : super(key: key);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  List<ItemQuantity> itemsList = []; // List to hold added items
  TextEditingController itemController = TextEditingController(); // Controller for input field
  int itemCount = 0; // Counter for the item quantity
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    itemsList = widget.eventEntity.items!.entries
        .map((entry) => ItemQuantity(itemName: entry.key, quantity: entry.value))
        .toList();

    const divider = Divider(
      thickness: 1,
      height: 3,
    );

    return Scaffold(
      appBar: AppBarWidget(
        pageName: widget.eventEntity.title ?? '',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: itemsList.length,
                itemBuilder: (context, index) {
                  return EventDetailPagePlaceholder(
                    itemTitle: itemsList[index].itemName ?? '',
                    itemCount: itemsList[index].quantity.toString(),
                    eventEntity: widget.eventEntity,
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
                  // Update Firestore with selected items
                  await _updateFirestore();

                  // Navigate to ViewOrderPage after placing the order
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewOrderPage(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Color when the button is disabled
                      }
                      return Colors.blue; // Color when the button is enabled
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
                            return Colors.grey; // Color when the button is disabled
                          }
                          return Colors.blue; // Color when the button is enabled
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
      final docRef = _firestore.collection('events').doc(widget.eventEntity.id);

      await docRef.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          Map<String, dynamic> data = docSnapshot.data()!;
          if (data.containsKey(newItem)) {
            int currentCount = data[newItem];
            data[newItem] = currentCount + itemCount;
          } else {
            data[newItem] = itemCount;
          }
          docRef.update(data);
        } else {
          docRef.set({newItem: itemCount});
        }
      });

      setState(() {
        bool itemExists = false;
        for (var item in itemsList) {
          if (item.itemName == newItem) {
            item.quantity += itemCount;
            itemExists = true;
            break;
          }
        }
        if (!itemExists) {
          itemsList.add(ItemQuantity(itemName: newItem, quantity: itemCount));
        }
        itemController.clear();
        itemCount = 0;
      });

      final eventEntity = EventEntity(
        id: widget.eventEntity.id,
        items: Map.fromIterable(
          itemsList,
          key: (item) => item.itemName,
          value: (item) => item.quantity,
        ),
        title: widget.eventEntity.title,
      );
      BlocProvider.of<TicketCubit>(context).addTicket(eventEntity);
    }
  }

  Future<void> _updateFirestore() async {
    final docRef = _firestore.collection('orders').doc();
    await docRef.set({
      'event_id': widget.eventEntity.id,
      'items': itemsList.map((item) => {'name': item.itemName, 'quantity': item.quantity}).toList(),
      'created_at': DateTime.now(),
    });
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }
}

class ItemQuantity {
  String? itemName;
  int quantity;

  ItemQuantity({
    this.itemName,
    this.quantity = 0,
  });
}