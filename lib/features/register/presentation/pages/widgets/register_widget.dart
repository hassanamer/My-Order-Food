import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/theming/theme_app.dart';
import 'package:order/core/widgets/botton_auth_row_widget.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_top_image_widget.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/register/presentation/pages/widgets/email_text_field_widget.dart';
import 'package:order/features/register/presentation/pages/widgets/mobile_text_field_widget.dart';
import 'package:order/features/register/presentation/pages/widgets/password_text_field_widget.dart';
import 'package:order/features/register/presentation/pages/widgets/register_text_field_widget.dart';
import 'package:order/features/register/presentation/pages/widgets/register_top_title_widget.dart';

class RegisterWidget extends StatefulWidget {
  final RegisterAccountEntity registerAccountEntity;

  const RegisterWidget({required this.registerAccountEntity, super.key});

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

  String? selectedGender;
  String? hasCar;
  String? deliveryPreference;
  bool isPasswordVisible = false;
  String? profileImageUrl;

  List<String> genderItems = <String>['Female', 'Male'];
  List<String> carItems = <String>['Yes', 'No'];
  List<String> deliveryItems = <String>[
    'Place the order',
    'Receive it at the gate'
  ];

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController();
    controllerPassword = TextEditingController();
    controllerName = TextEditingController();
    controllerEmail = TextEditingController();
    controllerGender = TextEditingController();
    controllerPhone = TextEditingController();
    _keyform = GlobalKey<FormState>();
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageRef.putFile(File(image.path));
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        profileImageUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox sizedBox = SizedBox(height: 12);
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const TopImage(),
            Form(
              key: _keyform,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    const RegisterTopTitleWidget(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          label: const Text(
                            'Pick Profile Image',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue[300],
                            // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 12.0),
                            elevation: 5, // Shadow
                          ),
                        ),
                        if (profileImageUrl != null)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              // Rounded corners
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              // Rounded corners
                              child: Image.network(
                                profileImageUrl!,
                                height: 150,
                                width: 150, // Ensure the image is a square
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RegisterTextFieldWidget(
                      controller: controllerUsername,
                      hintText: 'Username',
                      icon: Icons.title_outlined,
                      validatorWord: 'Username',
                    ),
                    sizedBox,
                    RegisterTextFieldWidget(
                      controller: controllerName,
                      hintText: 'Name',
                      icon: Icons.person_outline_rounded,
                      validatorWord: 'Name',
                    ),
                    sizedBox,
                    EmailTextFieldWidget(controllerEmail: controllerEmail),
                    sizedBox,
                    PasswordTextFieldWidget(
                        controllerPassword: controllerPassword),
                    sizedBox,
                    DropdownButtonFormField<String?>(
                      borderRadius: BorderRadius.circular(12),
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(.9),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          size: 24,
                          color: Colors.blue.shade900,
                        ),
                        hintText: 'Gender',
                        hintStyle: TextStyles
                            .font20BlueGradienteBoldForItemsList
                            .copyWith(
                          color: Colors.blue.shade900.withOpacity(.3),
                        ),
                        label: Text(
                          'Gender',
                          style: TextStyles.font20BlueGradienteBoldForItemsList
                              .copyWith(
                            color: Colors.blue.shade900.withOpacity(.3),
                          ),
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(.5),
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
                            color: authTextFromFieldErrorBorderColor
                                .withOpacity(.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedGender,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue.shade900,
                      ),
                      items: genderItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:
                                TextStyles.font20BlueGradienteBoldForItemsList,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value!;
                          controllerGender.text = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
                    ),
                    sizedBox,
                    DropdownButtonFormField<String?>(
                      borderRadius: BorderRadius.circular(12),
                      decoration: InputDecoration(
                        hintText: 'Do you have a car?',
                        hintStyle: TextStyles
                            .font20BlueGradienteBoldForItemsList
                            .copyWith(
                          color: Colors.blue.shade900.withOpacity(.3),
                        ),
                        label: Text(
                          'Do you have a car?',
                          style: TextStyles.font20BlueGradienteBoldForItemsList
                              .copyWith(
                            color: Colors.blue.shade900.withOpacity(.3),
                          ),
                        ),
                        fillColor: Colors.white.withOpacity(.9),
                        prefixIcon: Icon(
                          Icons.directions_car_outlined,
                          size: 24,
                          color: Colors.blue.shade900,
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
                            color: authTextFromFieldErrorBorderColor
                                .withOpacity(.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: hasCar,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue.shade900,
                      ),
                      items: carItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:
                                TextStyles.font20BlueGradienteBoldForItemsList,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          hasCar = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),
                    sizedBox,
                    DropdownButtonFormField<String?>(
                      borderRadius: BorderRadius.circular(12),
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(.9),
                        prefixIcon: deliveryPreference == 'Place the order'
                            ? Icon(
                                Icons.phone,
                                color: Colors.blue.shade900,
                                size: 24,
                              )
                            : Icon(
                                Icons.local_shipping,
                                size: 24,
                                color: Colors.blue.shade900,
                              ),
                        hintText:
                            'Do you want to place the order or receive it at the gate?',
                        hintStyle: TextStyles
                            .font20BlueGradienteBoldForItemsList
                            .copyWith(
                          color: Colors.blue.shade900.withOpacity(.3),
                        ),
                        label: Text(
                          'Do you want to place the order or receive it...',
                          style: TextStyles.font20BlueGradienteBoldForItemsList
                              .copyWith(
                            color: Colors.blue.shade900.withOpacity(.3),
                          ),
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
                            color: authTextFromFieldErrorBorderColor
                                .withOpacity(.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: deliveryPreference,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue.shade900,
                      ),
                      items: deliveryItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:
                                TextStyles.font20BlueGradienteBoldForItemsList,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          deliveryPreference = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),
                    sizedBox,
                    MobileTextFieldWidget(controllerPhone: controllerPhone),
                    sizedBox,
                    CommonElevatedButtonWidget(
                      width: MediaQuery.of(context).size.width * 0.9,
                      text: 'Sign up',
                      color: Colors.blue.shade300,
                      onPressed: () async {
                        if (_keyform.currentState!.validate()) {
                          context
                              .read<RegisterCubit>()
                              .registerAccountFromRemote(
                                context,
                                registerAccountEntity: RegisterAccountEntity(
                                    gender: controllerGender.text.trim(),
                                    name: controllerName.text,
                                    phoneNumber: controllerPhone.text,
                                    username: controllerUsername.text,
                                    hasCar: hasCar,
                                    deliveryPreference: deliveryPreference,
                                    profileImageUrl: profileImageUrl),
                                email: controllerEmail.text.trim(),
                                password: controllerPassword.text,
                              );
                        }
                      },
                    ),
                    BottomAuthRowWidget(
                      text: 'Already have an account?',
                      value: 'Login',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => const LoginPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
