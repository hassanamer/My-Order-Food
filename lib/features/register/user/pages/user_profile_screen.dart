import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/common_elevated_button_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/register/user/profile_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = '';
  String email = '';
  String phoneNumber = '';
  String gender = '';
  String profileImageUrl = '';
  File? _imageFile;

  bool _isEditing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<ProfileCubit>().fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      appBar: const AppBarWidget(
        pageName: 'Profile',
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (BuildContext context, ProfileState state) {
          if (state is ProfileLoaded) {
            userName = state.userName;
            email = state.email;
            phoneNumber = state.phoneNumber;
            gender = state.gender;
            profileImageUrl = state.profileImageUrl;
          }
        },
        builder: (BuildContext context, ProfileState state) {
          if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: GradientCircleAvatar(
                        profileImageUrl: profileImageUrl,
                        width: 140.w,
                        height: 140.h,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileInfoItem(
                        'Username', userName, _isEditing, true),
                    const SizedBox(height: 5),
                    _buildProfileInfoItem('Email', email, _isEditing, true),
                    const SizedBox(height: 5),
                    _buildProfileInfoItem(
                        'Phone', phoneNumber, _isEditing, true),
                    const SizedBox(height: 5),
                    _buildProfileInfoItem('Gender', gender, _isEditing, true),
                    const SizedBox(height: 30),
                    CommonElevatedButtonWidget(
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: Colors.blue.shade400,
                      text: _isEditing ? 'Done' : 'Edit Profile',
                      onPressed: () {
                        if (_isEditing &&
                            _formKey.currentState?.validate() == true) {
                          _formKey.currentState?.save();
                          context.read<ProfileCubit>().updateProfile(
                                userName: userName,
                                phoneNumber: phoneNumber,
                                gender: gender,
                                profileImageUrl: profileImageUrl,
                              );
                        }
                        _editProfile();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
              color: Colors.white.withOpacity(0.5),
              child: const LoadingWidget());
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });

    if (_imageFile != null) {
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && _imageFile != null) {
      try {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('Users')
            .child(currentUser.uid);
        await storageRef.putFile(_imageFile!);
        String downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .update(<Object, Object?>{'profileImageUrl': downloadUrl});

        setState(() {
          profileImageUrl = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _editProfile() async {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        try {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.uid)
              .update(<Object, Object?>{
            'userName': userName,
            'phoneNumber': phoneNumber,
            'gender': gender,
          });
        } catch (e) {
          print('Error updating profile: $e');
        }
      }
    }
  }

  IconData getIconForLabel(String label, String value) {
    switch (label) {
      case 'Phone':
        return Icons.phone;
      case 'Username':
        return Icons.person;
      case 'Email':
        return Icons.mail;
      case 'Gender':
        return value == 'Male' ? Icons.male : Icons.female;
      // Add cases for other labels if needed
      default:
        return Icons.text_fields; // Default icon
    }
  }

  Widget _buildProfileInfoItem(
      String label, String value, bool isEditing, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isEditing && isEditable
              ? Expanded(
                  child: TextFormField(
                    style: TextStyles.font20BlueGradienteBoldForItemsList,
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(.9),
                      border: const UnderlineInputBorder(),
                      hintStyle: TextStyles.font20BlueGradienteBoldForItemsList
                          .copyWith(
                        color: Colors.blue.shade900.withOpacity(.3),
                      ),
                      hintText: label,
                      label: Text(
                        '$label',
                        style: TextStyles.font20BlueGradienteBoldForItemsList
                            .copyWith(
                          color: Colors.blue.shade900.withOpacity(.3),
                        ),
                      ),
                      prefixIcon: Icon(
                        getIconForLabel(label, value),
                        color: Colors.blue.shade900,
                      ),
                    ),
                    initialValue: value,
                    onChanged: (String newValue) {
                      setState(() {
                        if (label == 'Phone') {
                          phoneNumber = newValue;
                        } else if (label == 'Username') {
                          userName = newValue;
                        } else if (label == 'Email') {
                          email = newValue;
                        } else if (label == 'Gender') {
                          gender = newValue;
                        }
                      });
                    },
                    validator: (String? newValue) =>
                        newValue!.isEmpty ? '$label cannot be empty' : null,
                    onSaved: (String? newValue) {
                      if (label == 'Phone') {
                        phoneNumber = newValue!;
                      } else if (label == 'Username') {
                        userName = newValue!;
                      } else if (label == 'Email') {
                        email = newValue!;
                      } else if (label == 'Gender') {
                        gender = newValue!;
                      }
                    },
                  ),
                )
              : GradientTile(value: value)
        ],
      ),
    );
  }
}

class GradientTile extends StatelessWidget {
  final String value;
  final double fontSize;
  final double borderRadius;

  const GradientTile({
    required this.value,
    super.key,
    this.fontSize = 20.0,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 55.h,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: <Color>[
            Colors.white,
            Colors.white70,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          value.toUpperCase(),
          style: TextStyles.font20BlueGradienteBoldForItemsList,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GradientCircleAvatar extends StatelessWidget {
  final String? profileImageUrl;
  double width;
  double height;

  GradientCircleAvatar(
      {required this.profileImageUrl,
      required this.width,
      required this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.white, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CircleAvatar(
          radius: 65,
          backgroundColor: Colors.white,
          backgroundImage: profileImageUrl!.isNotEmpty
              ? NetworkImage(profileImageUrl!)
              : null,
          child: profileImageUrl!.isEmpty
              ? const Icon(Icons.add_a_photo, size: 50, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
