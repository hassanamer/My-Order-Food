import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/handler_request_api.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';
import 'package:order/features/login/domain/usecases/login_usecase.dart';
import 'package:order/features/login/domain/usecases/remote_login_usecase.dart';
import 'package:order/features/login/domain/usecases/remote_logout_usecase.dart';
import 'package:order/features/login/presentation/cubit/login_state.dart';
import 'package:order/injection_container.dart';

class LoginCubit extends Cubit<LoginState> {
  late LoginUsecase loginUsecase;
  late RemoteLoginUsecase remoteLoginUsecase;
  late RemoteLogoutUsecase remoteLogoutUsecase;

  LoginCubit() : super(LoginStateInt());

  Future<void> remoteLogin(
      String email, String password, BuildContext context) async {
    emit(LoginStateLoading());

    final RemoteLoginUsecase remoteLoginUsecase = RemoteLoginUsecase(sl());

    try {
      emit(LoginStateLoading());
      handlerRequestApi(
        context: context,
        body: () async {
          final LoginBaseResponse loggedin =
              await remoteLoginUsecase.call(email, password);
          if (loggedin.status) {
            return emit(LoginSucessState('Hello,welcome back ;)'));
          } else {
            return emit(ErrorState(errorMessage: loggedin.message));
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(ErrorState(
        errorMessage: e.message.toString(),
      ));
    }
  }

  Future<void> login(String username, String password) async {
    try {
      emit(LoginStateLoading());

      final LoginBaseResponse logedin =
          await loginUsecase.call(username, password);
      if (logedin.status) {
        emit(SuccessState(logedin));
      } else {
        emit(ErrorState(errorMessage: logedin.message));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> logOut() async {
    emit(LogoutLoadingState());
    final RemoteLogoutUsecase remoteLogoutUsecase = RemoteLogoutUsecase(sl());
    try {
      emit(LogoutLoadingState());
      final LoginBaseResponse loggedout = await remoteLogoutUsecase.call();
      if (loggedout.status) {
        emit(SuccessLogoutState(loggedout));
      } else {
        emit(ErrorState(errorMessage: loggedout.message));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }
}
