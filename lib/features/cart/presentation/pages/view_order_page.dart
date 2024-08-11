import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/order_details_page/order_summary_page.dart';

import '../../../event/presentation/cubit/order_cubit.dart';

class ViewOrderPage extends StatefulWidget {
  final VoidCallback? onCalculate;

  const ViewOrderPage({Key? key, this.onCalculate});

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  late Stream<List<OrderEntity>> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = OrderCubit()
        .getOrdersStream(); // Assuming this returns a Stream<List<OrderEntity>>
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: const AppBarWidget(
        pageName: "Your Orders",
      ),
      body: StreamBuilder<List<OrderEntity>>(
        stream: _ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingWidget());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'You Didn\'t Try To Use Our App Before',
                style: TextStyles.font18BlueSemiBold,
              ),
            );
          }
          final orders = snapshot.data!;
          final filteredOrders = orders.where((orderEntity) {
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
              var orderEntity = filteredOrders[index];
              var orderId = orderEntity.id;
              var createdAt = orderEntity.createdAt != null
                  ? DateFormat('yyyy-MM-dd hh:mm a')
                      .format(orderEntity.createdAt!)
                  : 'Unknown';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSummaryPage(
                          orderId: orderId,
                          orderEntity: orderEntity,
                          onCalculate: widget.onCalculate),
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
