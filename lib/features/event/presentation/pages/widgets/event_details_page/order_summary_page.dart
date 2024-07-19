import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:order/core/widgets/app_bar_widget.dart';

class OrderSummaryPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderSummaryPage({
    Key? key,
    required this.orderId,
    required this.orderData,
  }) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> items = widget.orderData['items'];
    String createdAt = widget.orderData['created_at'] != null
        ? DateFormat('yyyy-MM-dd hh:mm a')
            .format((widget.orderData['created_at'] as Timestamp).toDate())
        : 'Unknown';

    // Group items by userId
    Map<String, List<dynamic>> itemsGroupedByUser = {};
    for (var item in items) {
      String userId = item['userId'];
      if (!itemsGroupedByUser.containsKey(userId)) {
        itemsGroupedByUser[userId] = [];
      }
      itemsGroupedByUser[userId]!.add(item);
    }

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
                  List<dynamic> userItems = itemsGroupedByUser[userId]!;
                  return _buildUserItems(userId, userItems);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Created At: $createdAt",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItems(String userId, List<dynamic> items) {
    Map<String, TextEditingController> priceControllers = {};
    double totalPrice = 0.0;

    return StatefulBuilder(
      builder: (context, setState) {
        double calculateTotalPrice() {
          for (var item in items) {
            double price =
                double.tryParse(priceControllers[item['id']]?.text ?? '0') ??
                    0.0;
            totalPrice += price * item['quantity'];
          }
          return totalPrice;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User: $userId",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...items.map((item) {
              String itemId = item['id'] ?? '';
              priceControllers[itemId] = TextEditingController();

              return _buildItem(
                itemName: item['itemName'],
                quantity: item['quantity'],
                priceController: priceControllers[itemId]!,
                onCalculate: () {
                  setState(() {
                    totalPrice = calculateTotalPrice() * 1.14; // Apply VAT
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 10),
            Text(
              'Total (including VAT 14%): ${totalPrice.toStringAsFixed(2)} L.E',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildItem({
    required String itemName,
    required int quantity,
    required TextEditingController priceController,
    required VoidCallback onCalculate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.fastfood, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$itemName × $quantity',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: onCalculate,
          ),
        ],
      ),
    );
  }
}
