import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';

import '../../../../restaurant/data/model/menu_model.dart';
import 'bottom_container_cart_widget.dart';
import 'cart_items_container.dart';

class CartWidget extends StatefulWidget {
  final List<MenuModel> menuModel;
  const CartWidget({
    super.key,
    required this.menuModel,
  });

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  Future<void> _refresh() async {
    setState(() {
      context.read<CartCubit>().getAllCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    // double delivartFee = 25.0;
    // double serviceFee = 12.0;

    // double totalPrice = 0.0; // Initialize the total price

    // // Calculate the total price by summing up the prices of all menu items
    // for (var menu in widget.menuModel) {
    //   totalPrice += menu.price;
    // }
    double cartTotalPrice() {
      double total = 0;
      double delivartFee = 25.0;
      double serviceFee = 12.0;
      for (var item in widget.menuModel) {
        num price = item.price;
        total += price + delivartFee + serviceFee;
      }
      return total;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: widget.menuModel.length,
              itemBuilder: (context, index) {
                const center = Center(
                  child: Divider(
                    thickness: 1,
                    color: Colors.orange,
                    indent: 5,
                    endIndent: 5,
                  ),
                );
                return CartItemsContainer(
                  center: center,
                  title: widget.menuModel[index].name,
                  subTitle: widget.menuModel[index].price,
                );
              },
              separatorBuilder: (context, index) => const Divider(thickness: 1),
            ),
          ),
        ),
        BottomContainerCartWidget(total: cartTotalPrice()),
      ],
    );
  }
}
