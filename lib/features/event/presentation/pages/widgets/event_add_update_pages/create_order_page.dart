import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/core/widgets/snackbar_message.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/event/presentation/cubit/order_state.dart';
import 'package:order/features/event/presentation/pages/order_food_home_page.dart';
import 'package:order/features/event/presentation/pages/widgets/event_add_update_pages/create_order_widget.dart';

class CreateOrderPage extends StatelessWidget {
  final CreateOrderEntity? eventEntity;
  final bool isUpdateEvent;

  const CreateOrderPage({
    Key? key,
    this.eventEntity,
    required this.isUpdateEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: "Start A New Order",
      ),
      body: _buildBody(context), // Pass context to the body builder
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is MessageAddDeleteUpdateEventState) {
              SnackBarMessage().showSuccessSnackBar(
                  message: state.message, context: context);
              context.read<OrderCubit>().getAllOrders();
              // Navigate to TicketPage and clear the navigation stack
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const OrderFoodHomePage()),
                  (route) => false);
            } else if (state is OrderErrorState) {
              final snackBar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is OrderLoadingState) {
              return const LoadingWidget();
            }
            return SingleChildScrollView(
              child: CreateOrderWidget(
                isUpdateEvent: isUpdateEvent,
                eventEntity: isUpdateEvent ? eventEntity : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
