import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:order/core/widgets/app_bar_widget.dart';

class OrderSummaryPage extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderSummaryPage({
    Key? key,
    required this.orderId,
    required this.orderData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = orderData['items'];
    String createdAt = orderData['created_at'] != null
        ? DateFormat('yyyy-MM-dd hh:mm a')
            .format((orderData['created_at'] as Timestamp).toDate())
        : 'Unknown';

    // Group items by userId
    Map<String, List<dynamic>> itemsGroupedByUser = {};
    for (var item in items) {
      String userId = item['user_id'];
      if (!itemsGroupedByUser.containsKey(userId)) {
        itemsGroupedByUser[userId] = [];
      }
      itemsGroupedByUser[userId]!.add(item);
    }

    return Scaffold(
      appBar: AppBarWidget(
        pageName: "Order #$orderId Summary",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User: $userId",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...items.map((item) {
          return _buildItem(
            itemName: item['item_name'],
            quantity: item['quantity'],
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildItem({
    required String itemName,
    required int quantity,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.fastfood, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            '$itemName - Quantity: $quantity',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
