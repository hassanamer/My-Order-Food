import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/theme_app.dart';
import 'package:order/core/widgets/botton_auth_row_widget.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/login/presentation/pages/widgtes/login_top_image_widget.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/register/presentation/pages/widgets/register_top_title_widget.dart';

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

  String? selectedGender;
  String? hasCar;
  String? deliveryPreference;
  bool isPasswordVisible = false;
  String? profileImageUrl;

  List<String> genderItems = ['Female', 'Male'];
  List<String> carItems = ['Yes', 'No'];
  List<String> deliveryItems = ['Place the order', 'Receive it at the gate'];

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
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        profileImageUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 12);
    return Form(
      key: _keyform,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Pick Profile Image"),
              ),
              if (profileImageUrl != null)
                Image.network(
                  profileImageUrl!,
                  height: 150,
                ),
              TextFormField(
                controller: controllerUsername,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              sizedBox,
              TextFormField(
                controller: controllerName,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              sizedBox,
              TextFormField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              sizedBox,
              TextFormField(
                controller: controllerPassword,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              sizedBox,
              DropdownButtonFormField<String?>(
                borderRadius: BorderRadius.circular(12),
                decoration: InputDecoration(
                  labelText: 'Gender',
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
                value: selectedGender,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: genderItems.map((String item) {
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
                    selectedGender = value!;
                    controllerGender.text = value;
                  });
                },
                validator: (value) {
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
                  labelText: 'Do you have a car?',
                  fillColor: authTextFromFieldFillColor.withOpacity(.3),
                  prefixIcon: const Icon(
                    Icons.directions_car,
                    size: 24,
                    color: authTextFromFieldHintTextColor,
                  ),
                  hintText: 'Do you have a car?',
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
                value: hasCar,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: carItems.map((String item) {
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
                    hasCar = value!;
                  });
                },
                validator: (value) {
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
                  labelText:
                      'Do you want to place the order or receive it at the gate?',
                  fillColor: authTextFromFieldFillColor.withOpacity(.3),
                  prefixIcon: deliveryPreference == 'Place the order'
                      ? const Icon(
                          Icons.phone,
                          size: 24,
                          color: authTextFromFieldHintTextColor,
                        )
                      : const Icon(
                          Icons.local_shipping,
                          size: 24,
                          color: authTextFromFieldHintTextColor,
                        ),
                  hintText:
                      'Do you want to place the order or receive it at the gate?',
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
                value: deliveryPreference,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: deliveryItems.map((String item) {
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
                    deliveryPreference = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              sizedBox,
              TextFormField(
                controller: controllerPhone,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              sizedBox,
              CommonElevatedButtonWidget(
                text: "Sign up",
                onPressed: () async {
                  if (_keyform.currentState!.validate()) {
                    context.read<RegisterCubit>().registerAccountFromRemote(
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
                text: "Already have an account?",
                value: "Login",
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
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
