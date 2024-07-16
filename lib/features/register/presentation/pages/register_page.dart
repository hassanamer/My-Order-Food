import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/snackbar_message.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/register/presentation/cubit/register_state.dart';
import 'package:order/features/register/presentation/pages/widgets/register_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterAccountEntity registerAccountEntity = RegisterAccountEntity();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocProvider<RegisterCubit>(
      create: (_) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is CreateUserSuccessfully) {
            registerAccountEntity = state.registerAccountEntity;
            FlutterToastMessageWidget().showSuccessFlutterToast(
                message: "You created an account successfully",
                context: context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
          } else if (state is RegisterErrorState) {
            FlutterToastMessageWidget().showSuccessFlutterToast(
                message: state.errorMessage, context: context);
          }
        },
        builder: (context, state) {
          return RegisterWidget(registerAccountEntity: registerAccountEntity);
        },
      ),
    );
  }
}
