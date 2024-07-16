import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_top_image_widget.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';

import '../../../../../core/theme_app.dart';
import '../../../../../core/widgets/botton_auth_row_widget.dart';
import '../../../../../core/widgets/common_elevated_button_widget.dart';
import '../../cubit/register_cubit.dart';
import 'email_text_field_widget.dart';
import 'mobile_text_field_widget.dart';
import 'password_text_field_widget.dart';
import 'register_text_field_widget.dart';
import 'register_top_title_widget.dart';

class RegisterWidget extends StatefulWidget {
  final RegisterAccountEntity registerAccountEntity;
  const RegisterWidget({super.key, required this.registerAccountEntity});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  late final TextEditingController controllerUsername;
  late final TextEditingController controllerPassword;
  late final TextEditingController controllerName;
  late final TextEditingController controllerEmail;
  late final TextEditingController controllerGender;
  late final TextEditingController controllerPhone;
  late final GlobalKey<FormState> _keyform;

  @override
  void initState() {
    controllerUsername = TextEditingController();
    controllerPassword = TextEditingController();
    controllerName = TextEditingController();
    controllerEmail = TextEditingController();
    controllerGender = TextEditingController();
    controllerPhone = TextEditingController();
    _keyform = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    controllerUsername.dispose();
    controllerPassword.dispose();
    controllerName.dispose();
    controllerEmail.dispose();
    controllerGender.dispose();
    controllerPhone.dispose();
    super.dispose();
  }

  String? selectedValue;
  List<String> items = [
    'Female',
    'Male',
  ];

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 12);
    return Form(
      key: _keyform,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const TopImage(),
              const SizedBox(
                width: double.infinity,
                height: 20,
              ),
              const RegisterTopTitleWidget(),
              RegisterTextFieldWidget(
                  controller: controllerUsername, hintText: 'Username'),
              sizedBox,
              RegisterTextFieldWidget(
                  controller: controllerName, hintText: 'Name'),
              sizedBox,
              EmailTextFieldWidget(controllerEmail: controllerEmail),
              sizedBox,
              PasswordTextFieldWidget(controllerPassword: controllerPassword),
              sizedBox,
              DropdownButtonFormField<String?>(
                borderRadius: BorderRadius.circular(12),
                decoration: InputDecoration(
                  fillColor: authTextFromFieldFillColor.withOpacity(.3),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 24,
                    color: authTextFromFieldHintTextColor,
                  ),
                  hintText: 'Gender',
                  hintStyle: const TextStyle(
                    color: authTextFromFieldHintTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: authTextFromFieldPorderColor.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: authTextFromFieldPorderColor.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: authTextFromFieldErrorBorderColor.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: selectedValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    controllerGender.text = value!;
                  });
                },
              ),
              sizedBox,
              MobileTextFieldWidget(controllerPhone: controllerPhone),
              sizedBox,
              CommonElevatedButton(
                text: "Sign up",
                onTap: () async {
                  setState(() {
                    if (_keyform.currentState!.validate()) {
                      context
                          .read<RegisterCubit>()
                          .registerAccountFromRemote(context,
                              registerAccountEntity: RegisterAccountEntity(
                                gender: controllerGender.text.trim(),
                                name: controllerName.text,
                                phoneNumber: controllerPhone.text,
                                username: controllerUsername.text,
                              ),
                              email: controllerEmail.text.trim(),
                              password: controllerPassword.text);
                    }
                  });
                },
              ),
              BottomAuthRowWidget(
                text: "Already have an account?",
                value: "Login",
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
