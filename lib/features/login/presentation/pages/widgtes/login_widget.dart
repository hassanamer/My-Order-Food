import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/botton_auth_row_widget.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_header_widget.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_textfield_widget.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_top_image_widget.dart';
import 'package:order/features/notification/data/datasources/push_notification_service.dart';
import 'package:order/features/register/presentation/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // if (kDebugMode) {
    // emailController.text = "hassanamer281@gmail.com";
    // passwordController.text = "P@ssw0rd";
    // }
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const TopImage(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const LoginHeaderWidget(),
                          const SizedBox(height: 20),
                          LoginTextFieldWidget(
                            hintText: 'Email',
                            obscureText: false,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue.shade900,
                            ),
                            controllerEmail: emailController,
                            onChanged: () {
                              _formKey.currentState?.validate();
                            },
                          ),
                          const SizedBox(height: 18),
                          LoginTextFieldWidget(
                            obscureText: passwordVisible,
                            controllerEmail: passwordController,
                            hintText: 'Password',
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.blue.shade900),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                color: Colors.blue.shade900,
                                passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          CommonElevatedButtonWidget(
                            width: MediaQuery.of(context).size.width * 0.9,
                            text: 'Log in',
                            onPressed: () async {
                              final PushNotificationService
                                  pushNotificationService =
                                  PushNotificationService();
                              pushNotificationService.updateUserFcmToken();
                              pushNotificationService.initialise();
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginCubit>().remoteLogin(
                                        emailController.text.trim(),
                                        passwordController.text,
                                        context,
                                      );
                                }
                              });
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                activeColor: Colors.blue,
                                value: _rememberMe,
                                onChanged: (bool? newValue) {
                                  setState(() => _rememberMe = newValue!);
                                  _handleRememberMe(newValue ?? false);
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyles.font18WhiteBold,
                              ),
                            ],
                          ),
                          BottomAuthRowWidget(
                            text: "Don't have an account ?",
                            value: 'Sign up',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const RegisterPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
