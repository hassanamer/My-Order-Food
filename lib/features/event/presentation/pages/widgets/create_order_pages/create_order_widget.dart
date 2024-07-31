import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/event/presentation/pages/widgets/create_order_pages/text_form_field_widget.dart';

import 'create_order_button.dart';

class CreateOrderWidget extends StatefulWidget {
  final OrderEntity? eventEntity;
  final bool isUpdateEvent;

  const CreateOrderWidget({
    Key? key,
    required this.eventEntity,
    required this.isUpdateEvent,
  }) : super(key: key);

  @override
  State<CreateOrderWidget> createState() => _CreateOrderWidgetState();
}

class _CreateOrderWidgetState extends State<CreateOrderWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  int itemCount = 0;

  late String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<OrderItem> itemList = [];
  Random random = Random();

  @override
  void initState() {
    if (widget.isUpdateEvent) {
      titleController.text = widget.eventEntity!.title!;
      widget.eventEntity!.items?.forEach((item) {
        itemList.add(OrderItem(
            itemName: item.itemName,
            quantity: item.quantity,
            userId: item.userId));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            name: "Title",
            multiLines: false,
            controller: titleController,
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: Text(itemList[index].itemName),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (itemList[index].quantity > 0) {
                        setState(() {
                          itemList[index].quantity--;
                        });
                      }
                    },
                  ),
                  Text('${itemList[index].quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        itemList[index].quantity++;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    labelText: "Item",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (itemList.isEmpty && value!.isEmpty) {
                      return "Item field can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (itemController.text.isNotEmpty) {
                    setState(() {
                      itemList.add(OrderItem(
                        itemName: itemController.text,
                        quantity: itemCount,
                        userId: userId,
                      ));
                      itemController.clear();
                      itemCount = 0;
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: "Item field can't be empty",
                      backgroundColor: ColorsManager.mainBlue,
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          CreateOrderButton(
            isUpdateEvent: widget.isUpdateEvent,
            onPressed: () {
              validateFormThenUpdateOrAddEvent();
            },
          ),
        ],
      ),
    );
  }

  void validateFormThenUpdateOrAddEvent() {
    final isValid = _formKey.currentState!.validate();

    // Check if the items list is empty
    if (itemList.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Your Items",
        backgroundColor: ColorsManager.mainBlue,
      );
      return;
    }

    // Check if any item's quantity is zero
    bool allItemsHaveQuantity = itemList.every((item) => item.quantity > 0);

    if (isValid && allItemsHaveQuantity) {
      final createOrderEntity = OrderEntity(
          id: widget.isUpdateEvent
              ? widget.eventEntity!.id
              : random.nextInt(10).toString(),
          title: titleController.text,
          items: itemList,
          userId: userId,
          createdAt: DateTime.now(),
          status: OrderStatusEnum.active);

      if (widget.isUpdateEvent) {
        BlocProvider.of<OrderCubit>(context).updateOrder(createOrderEntity);
      } else {
        BlocProvider.of<OrderCubit>(context).addOrder(createOrderEntity);
      }
    } else if (!allItemsHaveQuantity) {
      Fluttertoast.showToast(
        msg: "All items must have a quantity greater than zero",
        backgroundColor: ColorsManager.mainBlue,
      );
    }
  }
}
