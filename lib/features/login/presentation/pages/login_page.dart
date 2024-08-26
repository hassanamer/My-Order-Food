import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/persistent_bottom_nav_bar_widget.dart';
import 'package:order/core/widgets/snackbar_message.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/login/presentation/cubit/login_state.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_widget.dart';

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
        backgroundColor: Colors.blue[600],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // ignore: always_specify_types
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state is LoginSucessState) {
            FlutterToastMessageWidget().showSuccessFlutterToast(
                message: state.message, context: context);
            Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const NavBarWidget(),
                ));
          }

          if (state is ErrorState) {
            FlutterToastMessageWidget().showErrorFlutterToast(
                message: state.errorMessage, context: context);
          }
        },
        builder: (BuildContext context, LoginState state) {
          return const LoginWidget();
        },
      ),
    );
  }
}
