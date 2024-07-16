import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/cart/presentation/pages/cart_page.dart';
import 'package:order/features/event/presentation/cubit/ticket_cubit.dart';
import 'package:order/features/event/presentation/cubit/ticket_state.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/empty_list_widget.dart';
import 'package:order/features/event/presentation/pages/widgets/home_widgets/ticket_page_app_bar_title_widget.dart';

import 'widgets/home_widgets/ticket_widget.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    setState(() {
      context.read<TicketCubit>().getAllTickets();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleWidget: const TicketPageAppBarTitleWidget(),
        hideBackButton: true,
        actions: [
          Badge(
            child: IconButton(
              onPressed: () {
                context.read<CartCubit>().getAllCartItems();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartPage()));
              },
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) {
          if (state is TicketSuccessState) {
            context.read<TicketCubit>().getAllTickets();
          }
          if (state is TicketErrorState) {
            if (kDebugMode) {
              print(state.errorMessage);
            }
          }
          if (state is TicketLoadedState) {


            print(state.eventEntity);
          }
        },
        builder: (context, state) {
          if (state is TicketLoadedState) {
            if (state.eventEntity.isEmpty) {
              return const TicketEmptyListWidget();
            } else {
              return TicketWidget(
                eventEntity: state.eventEntity,
              );
            }
          } else if (state is TicketErrorState) {
            if (kDebugMode) {
              print(state.errorMessage);
            }
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
