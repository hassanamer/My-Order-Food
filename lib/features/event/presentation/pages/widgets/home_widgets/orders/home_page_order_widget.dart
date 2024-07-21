import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/orders/orders_list_title_widget.dart';

import '../../../../../../restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';
import '../home/custome_row_home_widget.dart';
import '../restaurants/get_restaurant_row_widget.dart';

class HomePageOrdersWidget extends StatefulWidget {
  final List<OrderEntity> orderEntity;

  // final List<RegisterAccountEntity> UserEntity;

  const HomePageOrdersWidget({Key? key, required this.orderEntity})
      : super(key: key);

  @override
  State<HomePageOrdersWidget> createState() => _HomePageOrdersWidgetState();
}

class _HomePageOrdersWidgetState extends State<HomePageOrdersWidget> {
  // final List<CreateOrderEntity> filter1 = [];

  Future<void> _refresh() async {
    setState(() {
      context.read<OrderCubit>().getAllOrders();
    });
    return await Future.delayed(
      const Duration(seconds: 0),
    );
  }

  // @override
  // void initState() {
  //   for (var event in widget.eventEntity) {
  //     for (var User in widget.UserEntity) {
  //       if (event.userId == User.idUser) {
  //         CreateOrderEntity eventEntity = CreateOrderEntity(
  //           userId: User.name,
  //           items: event.items,
  //           title: event.title,
  //           id: event.id,
  //         );
  //         filter1.add(eventEntity);
  //       }
  //     }
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      thickness: 1,
      height: 3,
    );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomRowHomePage(
              firstText: 'Resturant',
              secondText: 'SeeMore',
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllRestaurantPage()));
              }),
          const SizedBox(height: 16),
          const GetRestaurantRowWidget(),
          divider,
          Flexible(
            flex: 4,
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.orderEntity.length,
                itemBuilder: (context, index) {
                  return OrdersListTitleWidget(
                    title: widget.orderEntity[index].title ?? '',
                    eventEntity: widget.orderEntity[index],
                  );
                },
                separatorBuilder: (context, index) => divider),
          ),
        ],
      ),
    );
  }
}
