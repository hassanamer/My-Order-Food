import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order/core/theming/colors.dart';

import '../../../../../../core/services/notification_service.dart';
import '../../../../../../core/services/push_notification_service.dart';
import '../../../../../../core/theming/styles.dart';
import '../../../../../../core/widgets/common_elevated_button_widget.dart';
import '../../../../../register/data/models/register_account_model.dart';
import '../../../../../register/user/pages/user_profile_screen.dart';
import '../../../../domain/entities/order_entities.dart';
import '../../../../domain/remote_usecases/remote_get_user_order.dart';

class UserItemsTile extends StatefulWidget {
  final RegisterAccountModel user;
  final List<OrderItem> items;
  final OrderEntity orderEntity;
  final DateTime createdAt;
  final double userDeliveryFee;
  final double vat;
  final Function() updateOrder;
  bool isCurrentUserPlacerOrReceiver;

  UserItemsTile({
    super.key,
    required this.user,
    required this.items,
    required this.isCurrentUserPlacerOrReceiver,
    required this.updateOrder,
    required this.orderEntity,
    required this.createdAt,
    required this.userDeliveryFee,
    required this.vat,
  });

  @override
  _UserItemsTileState createState() => _UserItemsTileState();
}

class _UserItemsTileState extends State<UserItemsTile> {
  late GetUserUsecase getUserOrderUsecase;
  Map<String, List<OrderItem>> itemsGroupedByUser = {};
  Map<String, RegisterAccountModel> userMap = {};
  List<OrderItem> itemsList = [];
  bool isLoading = true;
  double totalPrice = 0;

  @override
  initState() {
    super.initState();
    itemsList = widget.orderEntity.items ?? [];
  }

  Widget getDivider() {
    return const Divider(
      color: Colors.white,
      thickness: 1,
      indent: 10,
      endIndent: 30,
    );
  }

  void updateItemsTotalPrice() {
    double total = 0.0;
    for (var item in widget.items) {
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
                colors: [Colors.blue.shade400, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 9,
                              color: Colors.transparent,
                            )
                          ],
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GradientCircleAvatar(
                                profileImageUrl: widget.user.profileImageUrl,
                                width: 100.w,
                                height: 100.h),
                            const SizedBox(width: 20),
                            Text(widget.user.name!.toUpperCase(),
                                style: TextStyles.font20WhiteBold),
                          ],
                        ),
                      ),
                    ),
                    getDivider(),
                    ...widget.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment:
                              // MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text('Item :',
                                      style: TextStyles.font20WhiteBold),
                                ),
                                // const Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Text(item.itemName,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.font20WhiteBold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text('Qty :',
                                      style: TextStyles.font20WhiteBold),
                                ),
                                // const Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Text("${item.quantity}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.font20WhiteBold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Visibility(
                                    visible:
                                        (widget.isCurrentUserPlacerOrReceiver),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Container(
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
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            label: Text(
                                              '${item.price ?? 'Price'}',
                                              style: const TextStyle(
                                                color: ColorsManager.darkBlue,
                                              ),
                                            ),
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
                                        style: TextStyles.font20WhiteBold),
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
                      children: [
                        Center(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "${widget.user.name}'s total price is: ${totalPrice.toStringAsFixed(2)} L.E",
                            style: TextStyles.font18WhiteBold,
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
                          width: 280.w,
                          text: 'Update Prices & Notify',
                          onPressed: () {
                            setState(
                              () {
                                widget.updateOrder();
                                PushNotificationService.sendNotificationToUser(
                                    widget.user.userId,
                                    "Your Total Price Is ${totalPrice.toStringAsFixed(2)}");
                                NotificationService.saveNotification(
                                    "Your Total Price Is",
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
