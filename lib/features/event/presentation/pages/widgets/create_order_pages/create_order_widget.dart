import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';

import '../../../../../../injection_container.dart';
import '../../../../domain/remote_usecases/add_order_usecase.dart';
import 'create_order_button.dart';

class CreateOrderWidget extends StatefulWidget {
  OrderEntity? eventEntity;
  final bool isUpdateEvent;

  CreateOrderWidget({
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
  double vat = 0;
  int itemCount = 0;
  Timer? _cancelTimer;
  late AddOrderUsecase addOrderUsecase;
  double keyboardHeight = 0;
  bool _hasStartedTyping = false;

  void _handleChange(String value) {
    setState(() {
      _hasStartedTyping = true;
    });
  }

  late String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<OrderItem> itemList = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    addOrderUsecase = sl();
    if (widget.isUpdateEvent) {
      titleController.text = widget.eventEntity!.title!;
      widget.eventEntity!.items?.forEach((item) {
        itemList.add(OrderItem(
          itemName: item.itemName,
          quantity: item.quantity,
          userId: item.userId,
        ));
      });
    }
    // _startCancellationTimer(); // Start timer only when creating a new order
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            // onChanged: _handleChange,
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (itemList.isEmpty && value!.isEmpty) {
                return "Title field can't be empty";
              }
              return null;
            },
            onChanged: (value) {
              _formKey.currentState?.validate();
            },
            onTap: () {
              setState(() {
                keyboardHeight = 300;
              });
            },
            onEditingComplete: () {
              setState(() {
                keyboardHeight = 0;
                FocusScope.of(context).unfocus();
              });
            },
            onTapOutside: (event) {
              setState(() {
                keyboardHeight = 0;
                FocusScope.of(context).unfocus();
              });
            },
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
                  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        setState(() {
                          itemList.removeAt(index);
                        });
                      })
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
                  onChanged: (value) {
                    _formKey.currentState?.validate();
                  },
                  onTap: () {
                    setState(() {
                      keyboardHeight = 300;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      keyboardHeight = 0;
                      FocusScope.of(context).unfocus();
                    });
                  },
                  onTapOutside: (event) {
                    setState(() {
                      keyboardHeight = 0;
                      FocusScope.of(context).unfocus();
                    });
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
          SizedBox(
            height: keyboardHeight,
          )
        ],
      ),
    );
  }

  void validateFormThenUpdateOrAddEvent() {
    final isValid = _formKey.currentState!.validate();

    if (itemList.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Your Items",
        backgroundColor: ColorsManager.mainBlue,
      );
      return;
    }

    bool allItemsHaveQuantity = itemList.every((item) => item.quantity > 0);

    if (isValid && allItemsHaveQuantity) {
      final createOrderEntity = OrderEntity(
          id: widget.isUpdateEvent
              ? widget.eventEntity!.id
              : random.nextInt(10).toString(),
          title: titleController.text,
          items: itemList,
          userId: userId,
          vat: vat,
          deliveryFees: 0.0,
          itemsTotalPricePerUser: {},
          createdAt: DateTime.now(),
          status: OrderStatusEnum.active);

      if (widget.isUpdateEvent) {
        BlocProvider.of<OrderCubit>(context).updateOrder(createOrderEntity);
      } else {
        BlocProvider.of<OrderCubit>(context).addOrder(createOrderEntity);
        widget.eventEntity = createOrderEntity;
        // _startCancellationTimer();
      }
    } else if (!allItemsHaveQuantity) {
      Fluttertoast.showToast(
        msg: "All items must have a quantity greater than zero",
        backgroundColor: ColorsManager.mainBlue,
      );
    }
  }

// void _startCancellationTimer() {
//   _cancelTimer?.cancel();
//   Future.delayed(const Duration(seconds: 30), () async {
//     if (widget.eventEntity != null &&
//         widget.eventEntity!.status != OrderStatusEnum.placed) {
//       await _cancelOrder();
//     }
//   });
// }
//
// Future<void> _cancelOrder() async {
//   if (widget.eventEntity == null) return;
//   setState(() {
//     widget.eventEntity!.status = OrderStatusEnum.cancelled;
//   });
//   await addOrderUsecase.updateOrderStatus(
//     widget.eventEntity!.id,
//     OrderStatusEnum.cancelled,
//   );
//   Fluttertoast.showToast(
//     msg: "Order has been cancelled due to inactivity",
//     backgroundColor: ColorsManager.mainBlue,
//   );
// }
//
// @override
// void dispose() {
//   _cancelTimer?.cancel();
//   super.dispose();
// }
}
