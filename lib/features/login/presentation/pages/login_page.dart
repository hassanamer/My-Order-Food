import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/snackbar_message.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/login/presentation/cubit/login_state.dart';

import '../../../../core/persistent_bottom_nav_bar_widget.dart';
import 'widgtes/login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSucessState) {
            FlutterToastMessageWidget().showSuccessFlutterToast(
                message: state.message, context: context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavBarWidget(),
                ));
          }

          if (state is ErrorState) {
            FlutterToastMessageWidget().showErrorFlutterToast(
                message: state.errorMessage, context: context);
          }
        },
        builder: (context, state) {
          return const LoginWidget();
        },
      ),
    );
  }
}
