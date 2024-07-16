import 'package:flutter/material.dart';

class PaymentSummaryWidget extends StatelessWidget {
  final String startName;
  final String endName;

  const PaymentSummaryWidget({
    required this.startName,
    required this.endName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            startName,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Text(
            endName,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
