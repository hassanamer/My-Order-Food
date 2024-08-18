import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/core/theming/font_weight_helper.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_details_page/order_summary_page.dart';

class ViewOrderPage extends StatefulWidget {
  final VoidCallback? onCalculate;

  const ViewOrderPage({super.key, this.onCalculate});

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  late Stream<List<OrderEntity>> _ordersStream;
  late bool isCreator;

  @override
  void initState() {
    super.initState();
    _ordersStream = OrderCubit().getOrdersStream();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.blue[600],
      appBar: const AppBarWidget(
        pageName: 'Your Orders',
      ),
      body: StreamBuilder<List<OrderEntity>>(
        stream: _ordersStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You Didn\'t Try To Use Our App Before',
                style: TextStyles.font18BlueSemiBold,
              ),
            );
          }
          final List<OrderEntity> orders = snapshot.data!;
          final List<OrderEntity> filteredOrders =
              orders.where((OrderEntity orderEntity) {
            isCreator = orderEntity.userId == currentUserId;
            bool isParticipant = orderEntity.items
                    ?.any((OrderItem item) => item.userId == currentUserId) ??
                false;
            return isCreator || isParticipant;
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (BuildContext context, int index) {
              OrderEntity orderEntity = filteredOrders[index];
              String orderId = orderEntity.id;
              // ignore: unnecessary_null_comparison
              String createdAt = orderEntity.createdAt != null
                  ? DateFormat('yyyy-MM-dd hh:mm a')
                      .format(orderEntity.createdAt)
                  : 'Unknown';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => OrderSummaryPage(
                          orderId: orderId,
                          orderEntity: orderEntity,
                          onCalculate: widget.onCalculate),
                    ),
                  );
                },
                child: _buildOrderItem(
                    title: 'Order ${orderEntity.title}',
                    createdAt: createdAt,
                    orderId: orderId,
                    isCreator: isCreator),
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
    required String orderId,
    required bool isCreator,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: <Color>[Colors.white, Colors.white70, Colors.blue[200]!],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.shopping_cart, color: Colors.blue.shade900),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeightHelper.bold,
                            fontFamily: 'Spectral',
                            color: Colors.blue.shade900,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(Icons.date_range, color: Colors.blue.shade900),
                        const SizedBox(width: 10),
                        Text(
                          createdAt.toString(),
                          style: TextStyles.font16BlueGradienteBoldForItemsList,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCreator)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await OrderCubit().deleteOrderById(orderId);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
