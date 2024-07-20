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
  Map<String, TextEditingController> priceControllers = {};
  Map<String, double> itemTotalPrices = {};
  Map<String, double> userTotalPrices = {};

  @override
  void initState() {
    super.initState();
    _initializePriceControllers();
  }

  void _initializePriceControllers() {
    List<dynamic> items = widget.orderData['items'] ?? [];
    for (var item in items) {
      String itemId = item['id'] ?? '';
      priceControllers[itemId] = TextEditingController();
      // Initialize the controller with the price if available
      priceControllers[itemId]!.text = item['price']?.toString() ?? '';
      priceControllers[itemId]!
          .addListener(() => _updateItemPrice(itemId, item['quantity'] ?? 1));
    }
  }

  void _updateItemPrice(String itemId, int quantity) {
    double price =
        double.tryParse(priceControllers[itemId]?.text ?? '0') ?? 0.0;
    setState(() {
      itemTotalPrices[itemId] = price * quantity;
      _updateUserTotalPrices();
    });
  }

  void _updateUserTotalPrices() {
    // Clear previous user totals
    userTotalPrices.clear();

    // Recalculate totals based on the current item prices
    Map<String, double> tempUserTotals = {};

    widget.orderData['items']?.forEach((item) {
      String userId = item['userId'] ?? 'Unknown';
      double itemTotal = itemTotalPrices[item['id']] ?? 0.0;

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
    List<dynamic> items = widget.orderData['items'] ?? [];
    String createdAt = widget.orderData['created_at'] != null
        ? DateFormat('yyyy-MM-dd hh:mm a')
            .format((widget.orderData['created_at'] as Timestamp).toDate())
        : 'Unknown';

    // Group items by userId
    Map<String, List<dynamic>> itemsGroupedByUser = {};
    for (var item in items) {
      String userId = item['userId'] ?? 'Unknown';
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
            const SizedBox(height: 10),
            Text(
              'Total (including VAT 14%): ${_calculateTotalPrice().toStringAsFixed(2)} L.E',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    itemTotalPrices.values.forEach((price) {
      total += price;
    });
    return total * 1.14; // Apply VAT
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
          String itemId = item['id'] ?? '';
          return _buildItem(
            itemName: item['itemName'] ?? 'Unknown',
            quantity: item['quantity'] ?? 1,
            priceController: priceControllers[itemId],
            itemId: itemId,
            itemQuantity: item['quantity'] ?? 1,
          );
        }).toList(),
        const SizedBox(height: 10),
        Text(
          'Total for User: ${userTotalPrices[userId]?.toStringAsFixed(2) ?? '0.00'} L.E',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildItem({
    required String itemName,
    required int quantity,
    required TextEditingController? priceController,
    required String itemId,
    required int itemQuantity,
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
            width: 100, // Adjust width to fit content
            child: TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateItemPrice(itemId, itemQuantity),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              if (priceController != null) {
                _updateItemPrice(itemId, itemQuantity);
              }
            },
          ),
          const SizedBox(width: 10),
          Text(
            'Total: ${itemTotalPrices[itemId]?.toStringAsFixed(2) ?? '0.00'} L.E',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
