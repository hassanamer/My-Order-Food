import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/register/presentation/cubit/register_state.dart';
import 'package:order/features/register/presentation/pages/widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  RegisterAccountModel registerAccountModel = RegisterAccountModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: 'Profile',
      ),
      body: BlocProvider<RegisterCubit>(
        create: (_) => RegisterCubit()..getUserInfo(registerAccountModel),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (BuildContext context, RegisterState state) {
            if (state is ProfileSuccessState) {
              registerAccountModel = state.registerAccountModel;
            } else if (state is ProfileErrorState) {
              if (kDebugMode) {
                print(state.errorMessage);
              }
            }
          },
          builder: (BuildContext context, RegisterState state) {
            return ProfileWidget(registerAccountModel: registerAccountModel);
          },
        ),
      ),
    );
  }
}
