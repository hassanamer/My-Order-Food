import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../profile_cubit.dart';

class UserProfileScreen extends StatefulWidget {
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<ProfileCubit>().fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            userName = state.userName;
            email = state.email;
            phoneNumber = state.phoneNumber;
            gender = state.gender;
            profileImageUrl = state.profileImageUrl;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: profileImageUrl.isEmpty
                            ? Icon(Icons.add_a_photo,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    _isEditing
                        ? TextFormField(
                            initialValue: userName,
                            onChanged: (value) => userName = value,
                            decoration: InputDecoration(labelText: 'Name'),
                            validator: (value) =>
                                value!.isEmpty ? 'Name cannot be empty' : null,
                          )
                        : Text(
                            userName,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                    SizedBox(height: 10),
                    _buildProfileInfoItem('Email', email, _isEditing, true),
                    _buildProfileInfoItem(
                        'Phone', phoneNumber, _isEditing, true),
                    _buildProfileInfoItem('Gender', gender, _isEditing, true),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _editProfile();
                        context.read<ProfileCubit>().updateProfile(
                              userName: userName,
                              phoneNumber: phoneNumber,
                              gender: gender,
                              profileImageUrl: profileImageUrl,
                            );
                      },
                      child: Text(_isEditing ? 'Done' : 'Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Users')
            .child(currentUser.uid);
        await storageRef.putFile(_imageFile!);
        String downloadUrl = await storageRef.getDownloadURL();

        // Update Firestore with the new profile image URL
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .update({'profileImageUrl': downloadUrl});

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
              .update({
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

  Widget _buildProfileInfoItem(
      String label, String value, bool isEditing, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          isEditing && isEditable
              ? Expanded(
                  child: TextFormField(
                    initialValue: value,
                    onChanged: (newValue) {
                      setState(() {
                        if (label == 'Phone') {
                          phoneNumber = newValue;
                        } else if (label == 'Gender') {
                          gender = newValue;
                        }
                      });
                    },
                    validator: (newValue) =>
                        newValue!.isEmpty ? '$label cannot be empty' : null,
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
