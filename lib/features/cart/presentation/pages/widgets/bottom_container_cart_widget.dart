import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/cart/presentation/pages/widgets/cart_alert_dialog_widget.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/menuu_pagee.dart';

class BottomContainerCartWidget extends StatelessWidget {
  final double total;

  const BottomContainerCartWidget({
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text('$total'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 120,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => MenuuPagee(),
                  )),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 207, 78, 27))),
                  child: const Text('Add Item'),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                height: 40,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    showAlertDialog(context, isCloseDismissible: true);
                    context.read<CartCubit>().clearCartItems();
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Check out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
