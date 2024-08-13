import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/home/row_image_text_restaurant_widget.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_state.dart';

class GetRestaurantRowWidget extends StatefulWidget {
  const GetRestaurantRowWidget({super.key});

  @override
  State<GetRestaurantRowWidget> createState() => _GetRestaurantRowWidgetState();
}

class _GetRestaurantRowWidgetState extends State<GetRestaurantRowWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantCubit, RestaurantState>(
      listener: (BuildContext context, RestaurantState state) {
        if (state is RestaurantLoading) {
          const LoadingWidget();
        }
        if (state is RestaurantError) {
          if (kDebugMode) {
            print(state.errorMessage);
          }
        }
      },
      builder: (BuildContext context, RestaurantState state) {
        if (state is RestaurantLoadedState) {
          return RowImageTextRestaurantWidget(
              restaurantModel: state.restaurantModel);
        }
        return Stack(
          children: <Widget>[
            Container(
                color: Colors.white.withOpacity(0.5),
                child: const LoadingWidget()),
          ],
        );
      },
    );
  }
}
