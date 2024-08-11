import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_state.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_widget.dart';

class AllRestaurantPage extends StatefulWidget {
  const AllRestaurantPage({super.key});

  @override
  State<AllRestaurantPage> createState() => _AllRestaurantPageState();
}

class _AllRestaurantPageState extends State<AllRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: "Restaurants",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<RestaurantCubit, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoading) {
              return Stack(
                children: [
                  Container(
                      color: Colors.white.withOpacity(0.5),
                      child: LoadingWidget()),
                ],
              );
            } else if (state is RestaurantLoadedState) {
              return AllRestaurantWidget(
                  restaurantModel: state.restaurantModel);
            } else if (state is RestaurantError) {
              if (kDebugMode) {
                print(state.errorMessage);
              }
            }
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      color: Colors.white.withOpacity(0.5),
                      child: LoadingWidget()),
                ),
              ],
            );
          },
          listener: (context, state) {
            if (state is RestaurantError) {
              if (kDebugMode) {
                print(state.errorMessage);
              }
            }
          },
        ),
      ),
    );
  }
}
