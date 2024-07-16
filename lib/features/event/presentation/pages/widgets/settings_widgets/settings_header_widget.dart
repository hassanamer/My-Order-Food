import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/features/register/user/pages/user_profile_screen.dart';

class SettingsHeaderWidget extends StatefulWidget {
  const SettingsHeaderWidget({Key? key}) : super(key: key);

  @override
  _SettingsHeaderWidgetState createState() => _SettingsHeaderWidgetState();
}

class _SettingsHeaderWidgetState extends State<SettingsHeaderWidget> {
  String userName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot['userName'] ?? '';
          email = userSnapshot['email'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserProfileScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 9, color: Color.fromRGBO(179, 192, 195, 0.08)),
          ],
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: const Color.fromRGBO(72, 129, 255, 0.06),
                radius: 50,
                child: Image.asset('assets/images/profile.png')),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    email,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
