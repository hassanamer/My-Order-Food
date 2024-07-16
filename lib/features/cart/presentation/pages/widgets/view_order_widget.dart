import 'package:flutter/material.dart';

import '../../../../restaurant/data/model/menu_model.dart';

class ViewOrderWidget extends StatelessWidget {
  final List<MenuModel> menuModel;
  const ViewOrderWidget({
    super.key,
    required this.menuModel,
  });

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;

    // Calculate the total price by summing up the prices of all menu items
    for (var menu in menuModel) {
      totalPrice += menu.price;
    }

    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            const Text(
              'Your Order',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 24),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                itemCount: menuModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(menuModel[index].name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 25),
                      Text('EGP: ${menuModel[index].price}'),
                    ],
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  'Payment total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
                Text(
                  'EGP: $totalPrice',
                ),
              ],
            ),
          ],
        ));
  }
}
