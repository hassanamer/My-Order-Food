import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/cart/presentation/cubit/cart_state.dart';
import 'package:order/features/cart/presentation/pages/widgets/cart_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: 'Cart',
      ),
      // ignore: always_specify_types
      body: BlocProvider(
        create: (BuildContext context) => CartCubit()..getAllCartItems(),
        child: BlocConsumer<CartCubit, CartState>(
          listener: (BuildContext context, CartState state) {
            if (state is CartError) {
              if (kDebugMode) {
                print(state.errorMessage);
              }
            }
          },
          builder: (BuildContext context, CartState state) {
            if (state is CartItemsLoadded) {
              return CartWidget(menuModel: state.menuModel);
            } else if (state is EmptyCart) {
              return const Center(child: Text('Your cart is empty....!'));
            }
            return Stack(
              children: <Widget>[
                Container(
                    color: Colors.white.withOpacity(0.5),
                    child: const LoadingWidget()),
              ],
            );
          },
        ),
      ),
    );
  }
}
