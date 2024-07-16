import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:order/core/theme_app.dart';
import 'package:order/features/cart/presentation/pages/widgets/payment_summary_widget.dart';

import 'cart_title_card_widget.dart';

class CartItemsContainer extends StatefulWidget {
  const CartItemsContainer({
    Key? key,
    required this.center,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final Center center;
  final String title;
  final int subTitle;
  @override
  State<CartItemsContainer> createState() => _CartItemsContainerState();
}

class _CartItemsContainerState extends State<CartItemsContainer> {
  int count = 1;
  double delivartFee = 25.0;
  double serviceFee = 12.0;
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          CartTitleCardWidget(title: widget.title),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CartTitleCardWidget(
                title: "EGP: ${widget.subTitle * count}",
                textStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                ),
              ),
              CounterButton(
                  buttonColor: appTheme.colorScheme.error,
                  count: count,
                  onChange: (value) {
                    setState(() {
                      count = value;
                      if (count < 1) {
                        count++;
                      }
                    });
                  },
                  loading: false),
            ],
          ),
          widget.center,
          PaymentSummaryWidget(
              startName: "Dilevry", endName: delivartFee.toString()),
          PaymentSummaryWidget(
              startName: "service", endName: serviceFee.toString()),
          PaymentSummaryWidget(
              startName: "Total",
              endName:
                  "EGP: ${widget.subTitle * count + delivartFee + serviceFee}"),
        ],
      ),
    );
  }
}
