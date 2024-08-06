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
        pageName: "Cart",
      ),
      body: BlocProvider(
        create: (context) => CartCubit()..getAllCartItems(),
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              if (kDebugMode) {
                print(state.errorMessage);
              }
            }
          },
          builder: (context, state) {
            if (state is CartItemsLoadded) {
              return CartWidget(menuModel: state.menuModel);
            } else if (state is EmptyCart) {
              return const Center(child: Text('Your cart is empty....!'));
            }
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    child: Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.white.withOpacity(0.5),
                            child: Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                  color: Colors.white.withOpacity(0.5),
                                  child: LoadingWidget()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
