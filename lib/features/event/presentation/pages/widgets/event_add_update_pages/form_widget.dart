import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/presentation/cubit/ticket_cubit.dart';
import 'package:order/features/event/presentation/pages/widgets/event_add_update_pages/form_submit_btn.dart';
import 'package:order/features/event/presentation/pages/widgets/event_add_update_pages/text_form_field_widget.dart';

import '../../../../../../core/persistent_bottom_nav_bar_widget.dart';

class FormWidget extends StatefulWidget {
  final EventEntity? eventEntity;
  final bool isUpdateEvent;

  const FormWidget({
    Key? key,
    required this.eventEntity,
    required this.isUpdateEvent,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  int itemCount = 0;
  List<ItemQuantity> itemsList = []; // List to store items and their quantities
  Random random = Random();

  @override
  void initState() {
    if (widget.isUpdateEvent) {
      titleController.text = widget.eventEntity!.title!;
      // Load existing items and quantities into the list
      widget.eventEntity!.items?.forEach((itemName, quantity) {
        itemsList.add(ItemQuantity(itemName: itemName, quantity: quantity));
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
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: Text(itemsList[index].itemName),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (itemsList[index].quantity > 0) {
                        setState(() {
                          itemsList[index].quantity--;
                        });
                      }
                    },
                  ),
                  Text('${itemsList[index].quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        itemsList[index].quantity++;
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
                  decoration: InputDecoration(
                    labelText: "Item",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (itemsList.isEmpty && value!.isEmpty) {
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
                      itemsList.add(ItemQuantity(
                        itemName: itemController.text,
                        quantity: itemCount,
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
          FormSubmitBtn(
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
    if (itemsList.isEmpty) {
      Fluttertoast.showToast(
        msg: "Items list is empty",
        backgroundColor: ColorsManager.mainBlue,
      );
      return;
    }

    // Check if any item's quantity is zero
    bool allItemsHaveQuantity = itemsList.every((item) => item.quantity > 0);

    if (isValid && allItemsHaveQuantity) {
      Fluttertoast.showToast(
        msg: "Event ${widget.isUpdateEvent ? 'updated' : 'added'} successfully",
        backgroundColor: ColorsManager.mainBlue,
      );

      final eventEntity = EventEntity(
        id: widget.isUpdateEvent
            ? widget.eventEntity!.id
            : random.nextInt(10).toString(),
        title: titleController.text,
        items: {for (var item in itemsList) item.itemName: item.quantity},
        item: itemController.text,
      );

      Get.to(() => const NavBarWidget());

      if (widget.isUpdateEvent) {
        BlocProvider.of<TicketCubit>(context).updateTicket(eventEntity);
      } else {
        BlocProvider.of<TicketCubit>(context).addTicket(eventEntity);
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const NavBarWidget(),
      ));
    } else if (!allItemsHaveQuantity) {
      Fluttertoast.showToast(
        msg: "All items must have a quantity greater than zero",
        backgroundColor: ColorsManager.mainBlue,
      );
    }
  }
}

class ItemQuantity {
  final String itemName;
  int quantity;

  ItemQuantity({
    required this.itemName,
    this.quantity = 0,
  });
}
