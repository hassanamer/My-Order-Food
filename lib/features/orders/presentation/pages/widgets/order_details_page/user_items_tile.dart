import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/features/notification/data/datasources/push_notification_service.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_user_orders_usecase.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/features/register/user/pages/user_profile_screen.dart';

// ignore: must_be_immutable
class UserItemsTile extends StatefulWidget {
  final RegisterAccountModel user;
  final List<OrderItemModel> items;
  final OrderEntity orderEntity;
  final DateTime createdAt;
  final double userDeliveryFee;
  final double vat;
  final Function() updateOrder;
  bool isCurrentUserPlacerOrReceiver;

  UserItemsTile({
    required this.user,
    required this.items,
    required this.isCurrentUserPlacerOrReceiver,
    required this.updateOrder,
    required this.orderEntity,
    required this.createdAt,
    required this.userDeliveryFee,
    required this.vat,
    super.key,
  });

  @override
  _UserItemsTileState createState() => _UserItemsTileState();
}

class _UserItemsTileState extends State<UserItemsTile> {
  late GetUsersUsecase getUserOrderUsecase;
  Map<String, List<OrderItemModel>> itemsGroupedByUser =
      <String, List<OrderItemModel>>{};
  Map<String, RegisterAccountModel> userMap = <String, RegisterAccountModel>{};
  List<OrderItemModel> itemsList = <OrderItemModel>[];
  bool isLoading = true;
  double totalPrice = 0;

  @override
  initState() {
    super.initState();
    itemsList = widget.orderEntity.items ?? <OrderItemModel>[];
  }

  Widget getDivider() {
    return Divider(
      color: Colors.blue[900],
      thickness: 1,
      indent: 10,
      endIndent: 30,
    );
  }

  void updateItemsTotalPrice() {
    double total = 0.0;
    for (OrderItemModel item in widget.items) {
      total += item.itemTotalPrice ?? 0;
    }
    widget.orderEntity.itemsTotalPricePerUser[widget.user.userId!] = total;
  }

  void updateTotalPrice() {
    if (widget.orderEntity.itemsTotalPricePerUser
            .containsKey(widget.user.userId!) ==
        false) {
      return;
    }
    totalPrice =
        widget.orderEntity.itemsTotalPricePerUser[widget.user.userId!]! +
            widget.userDeliveryFee;
    if (widget.vat != 0) {
      totalPrice += widget.vat * totalPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    updateTotalPrice();
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
                colors: <Color>[
                  Colors.white,
                  Colors.blue[100]!,
                  Colors.white70,
                ],
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
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: const BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 9,
                              color: Colors.transparent,
                            )
                          ],
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GradientCircleAvatar(
                                profileImageUrl: widget.user.profileImageUrl,
                                width: 100.w,
                                height: 100.h),
                            const SizedBox(width: 20),
                            Text(
                              widget.user.name!.toUpperCase(),
                              style: TextStyles
                                  .font20BlueGradienteBoldForItemsList,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    getDivider(),
                    ...widget.items.map(
                      (OrderItemModel item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              // mainAxisAlignment:
                              // MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text('Item :',
                                      style: TextStyles
                                          .font20BlueGradienteBoldForItemsList),
                                ),
                                // const Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Text(item.itemName,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles
                                          .font20BlueGradienteBoldForItemsList),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text('Qty :',
                                      style: TextStyles
                                          .font20BlueGradienteBoldForItemsList),
                                ),
                                // const Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Text('${item.quantity}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles
                                          .font20BlueGradienteBoldForItemsList),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  child: Visibility(
                                    visible:
                                        (widget.isCurrentUserPlacerOrReceiver),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: SizedBox(
                                        height: 40.0.h,
                                        width: 50.0.w,
                                        child: TextField(
                                          onChanged: (String price) {
                                            setState(() {
                                              item.price =
                                                  double.tryParse(price);
                                              item.itemTotalPrice =
                                                  (item.price ?? 0.0) *
                                                      item.quantity;
                                              updateItemsTotalPrice();
                                              updateTotalPrice();
                                            });
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            label: Text('Price',
                                                style: TextStyles
                                                    .font16BlueGradienteBoldForItemsList),
                                            hintText:
                                                '${item.price ?? 'Price'}',
                                            border: const OutlineInputBorder(),
                                            // filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minWidth: 60),
                                    child: Text('${item.itemTotalPrice ?? ""}',
                                        style: TextStyles
                                            .font20BlueGradienteBoldForItemsList),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            getDivider(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "${widget.user.name}'s total price is: ${totalPrice.toStringAsFixed(2)} L.E",
                            style:
                                TextStyles.font20BlueGradienteBoldForItemsList,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    getDivider(),
                    Visibility(
                      visible: (widget.isCurrentUserPlacerOrReceiver),
                      child: Center(
                        child: CommonElevatedButtonWidget(
                          width: MediaQuery.of(context).size.width * 0.7,
                          text: 'Update Prices & Notify',
                          onPressed: () {
                            setState(
                              () {
                                widget.updateOrder();
                                PushNotificationService.sendNotificationToUser(
                                    widget.user.userId,
                                    'Your Total Price Is ${totalPrice.toStringAsFixed(2)}');
                                PushNotificationService.saveNotification(
                                    'Your Total Price Is',
                                    totalPrice.toStringAsFixed(2),
                                    widget.user.userId);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
