import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/order_details_page/order_summary_page.dart';

class ViewOrderPage extends StatelessWidget {
  final VoidCallback? onCalculate;

  const ViewOrderPage({Key? key, this.onCalculate});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: const AppBarWidget(
        pageName: "Your Orders",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Order').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders available'));
          }
          final filteredOrders = snapshot.data!.docs.where((doc) {
            var orderMap = doc.data() as Map<String, dynamic>;
            var orderEntity = OrderEntity.fromMap(orderMap);

            bool isCreator = orderEntity.userId == currentUserId;
            bool isParticipant = orderEntity.items
                    ?.any((item) => item.userId == currentUserId) ??
                false;

            return isCreator || isParticipant;
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text('No orders available'));
          }
          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              var orderMap =
                  filteredOrders[index].data() as Map<String, dynamic>;
              var orderEntity = OrderEntity.fromMap(orderMap);
              var orderId = orderEntity.id;
              var createdAt = orderEntity.createdAt != null
                  ? DateFormat('yyyy-MM-dd hh:mm a')
                      .format(orderEntity.createdAt)
                  : 'Unknown';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSummaryPage(
                          orderId: orderId,
                          orderEntity: orderEntity,
                          onCalculate: onCalculate),
                    ),
                  );
                },
                child: _buildOrderItem(
                  title: 'Order ${orderEntity.title}',
                  createdAt: createdAt,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderItem({
    required String title,
    required String createdAt,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  createdAt.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
