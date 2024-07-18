import 'package:flutter/material.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/event_details_page/evebt_details_page_item_tile.dart';

class OrderSummaryPage extends StatelessWidget {
  final String orderId;
  final String createdAt;
  final List<dynamic> orderItems; // Ensure this matches your OrderItem model

  const OrderSummaryPage({
    Key? key,
    required this.orderId,
    required this.createdAt,
    required this.orderItems, // Make sure orderItems is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group items by userId
    Map<String, List<OrderItem>> itemsGroupedByUser = {};
    for (var item in orderItems) {
      String userId = item.userId;
      itemsGroupedByUser.putIfAbsent(userId, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBarWidget(pageName: 'Order Summary'),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: itemsGroupedByUser.isEmpty
                  ? Center(
                      child: Text(
                        'No items available',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: itemsGroupedByUser.length,
                      itemBuilder: (context, index) {
                        String userId =
                            itemsGroupedByUser.keys.elementAt(index);
                        List<OrderItem> userItems =
                            itemsGroupedByUser[userId] ?? [];
                        return _buildUserOrderTile(userId, userItems);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #$orderId',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Date Created: $createdAt',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Divider(color: Colors.white),
      ],
    );
  }

  Widget _buildUserOrderTile(String userId, List<OrderItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User: $userId', // Customize as per your user data structure
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            OrderItem item = items[index];
            return EventDetailPageItemTile(
              userId: userId, // Pass userId if needed in the tile
              items: [item], // Wrap in a list for the tile
            );
          },
        ),
      ],
    );
  }
}
