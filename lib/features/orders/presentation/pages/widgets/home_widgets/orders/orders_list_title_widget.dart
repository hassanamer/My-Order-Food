import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_details_page/order_details_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_page.dart';

class OrdersListTitleWidget extends StatefulWidget {
  const OrdersListTitleWidget({
    required this.orderEntity,
    required this.title,
    super.key,
  });

  final OrderEntity orderEntity;
  final String title;

  @override
  State<OrdersListTitleWidget> createState() => _OrdersListTitleWidgetState();
}

class _OrdersListTitleWidgetState extends State<OrdersListTitleWidget> {
  LinearGradient getGradientForStatus(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.active:
        return const LinearGradient(
          colors: <Color>[Colors.yellow, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case OrderStatusEnum.placed:
        return const LinearGradient(
          colors: <Color>[Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case OrderStatusEnum.arrived:
        return const LinearGradient(
          colors: <Color>[Colors.green, Colors.lightGreenAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case OrderStatusEnum.cancelled:
        return const LinearGradient(
          colors: <Color>[Colors.red, Colors.deepOrangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
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
                colors: <Color>[Colors.blue.shade400, Colors.blue.shade900],
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          OrderDetailsPage(orderEntity: widget.orderEntity)));
                },
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.white,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  OrderStatusPage(
                                orderEntity: widget.orderEntity,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient:
                                getGradientForStatus(widget.orderEntity.status),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            widget.orderEntity.status.name.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: OrderStatusEnum.getStatusColor(
                                      widget.orderEntity.status),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
