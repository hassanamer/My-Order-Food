import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_state.dart';

import 'row_image_text_restaurant_widget.dart';

class GetRestaurantRowWidget extends StatefulWidget {
  const GetRestaurantRowWidget({super.key});

  @override
  State<GetRestaurantRowWidget> createState() => _GetRestaurantRowWidgetState();
}

class _GetRestaurantRowWidgetState extends State<GetRestaurantRowWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantCubit, RestaurantState>(
      listener: (context, state) {
        if (state is RestaurantLoading) {
          const LoadingWidget();
        }
        if (state is RestaurantError) {
          if (kDebugMode) {
            print(state.errorMessage);
          }
        }
      },
      builder: (context, state) {
        if (state is RestaurantLoadedState) {
          return RowImageTextRestaurantWidget(
              restaurantModel: state.restaurantModel);
        }
        return const LoadingWidget();
      },
    );
  }
}
