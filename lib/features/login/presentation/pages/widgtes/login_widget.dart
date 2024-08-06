import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/services/push_notification_service.dart';
import '../../../../../core/widgets/botton_auth_row_widget.dart';
import '../../../../../core/widgets/common_elevated_button_widget.dart';
import '../../../../register/presentation/pages/register_page.dart';
import '../../cubit/login_cubit.dart';
import 'login_header_widget.dart'; // Make sure to import your login header widget
import 'login_textfield_widget.dart';
import 'login_top_image_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _rememberMe = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = (prefs.getBool('remember_me') ?? false);
      if (_rememberMe) {
        emailController.text = (prefs.getString('email') ?? '');
        passwordController.text = (prefs.getString('password') ?? '');
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const OrderFoodHomePage(),
        //   ),
        // );
      }
    });
  }

  Future<void> _handleRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = value;
      prefs.setBool('remember_me', _rememberMe);
      if (_rememberMe) {
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      } else {
        prefs.remove('email');
        prefs.remove('password');
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      emailController.text = "hassanamer281@gmail.com";
      passwordController.text = "P@ssw0rd";
    }
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopImage(),
              const LoginHeaderWidget(),
              const SizedBox(height: 15),
              LoginTextFieldWidget(
                hintText: "Email",
                obscureText: false,
                prefixIcon: const Icon(Icons.email),
                controllerEmail: emailController,
                onChanged: () {
                  _formKey.currentState?.validate();
                },
              ),
              const SizedBox(height: 12),
              LoginTextFieldWidget(
                obscureText: passwordVisible,
                controllerEmail: passwordController,
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: Icon(passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
              ),
              const SizedBox(height: 12),
              CommonElevatedButtonWidget(
                text: "Log in",
                onPressed: () async {
                  final PushNotificationService pushNotificationService =
                      PushNotificationService(
                    _firebaseMessaging,
                  );
                  pushNotificationService.updateUserFcmToken();
                  pushNotificationService.initialise();
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginCubit>().remoteLogin(
                          emailController.text.trim(),
                          passwordController.text,
                          context);
                    }
                  });
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (newValue) {
                      setState(() => _rememberMe = newValue!);
                      _handleRememberMe(newValue ?? false);
                    },
                  ),
                  const Text('Remember Me'),
                ],
              ),
              BottomAuthRowWidget(
                text: "Don't have an account",
                value: "Sign up",
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
