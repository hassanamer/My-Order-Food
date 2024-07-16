import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/presentation/cubit/ticket_cubit.dart';
import 'package:order/features/event/presentation/pages/ticket_page.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/add_restaurant_page.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';

import '../features/login/presentation/cubit/login_cubit.dart';

class NavigationDrawerr extends StatefulWidget {
  const NavigationDrawerr({super.key});

  @override
  State<NavigationDrawerr> createState() => _NavigationDrawerrState();
}

class _NavigationDrawerrState extends State<NavigationDrawerr> {
  User? user = FirebaseAuth.instance.currentUser;

  RegisterAccountModel loggedInUser = RegisterAccountModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = RegisterAccountModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: ListView(
          children: [
            SingleChildScrollView(
                child: Column(
              children: <Widget>[
                buildMenuItems(context),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) => Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: CircleAvatar(
              radius: 50,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child:
                    ClipOval(child: Image.asset("assets/images/profile.png")),
              ),
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Align(
              alignment: const Alignment(0, 0),
              child: Text(
                loggedInUser.username ?? '',
                style: const TextStyle(
                  wordSpacing: 2,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  fontSize: 24,
                  color: Colors.black,
                ),
              )),
          Align(
              alignment: const Alignment(0, 0),
              child: Text(
                user!.email ?? '',
                style: const TextStyle(
                  wordSpacing: 5,
                  fontWeight: FontWeight.w500,
                  height: 2,
                  fontSize: 18,
                  color: Colors.black,
                ),
              )),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              context.read<TicketCubit>().getAllTickets();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TicketPage()));
            },
          ),
          ListTile(
            title: const Text('Restaurants'),
            leading: const Icon(Icons.restaurant),
            onTap: () {
              context.read<RestaurantCubit>().getAllRestaurants();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AllRestaurantPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box_rounded),
            title: const Text(
              'Add Restaurant',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RestaurantPage()));
            },
          ),
          const Divider(
            thickness: 1,
            indent: 30,
          ),
          ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                                child: const Text("Confirm"),
                                onPressed: () {
                                  setState(() {
                                    context.read<LoginCubit>().logOut();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  });
                                })
                          ]);
                    });
              }),
        ],
      );
}
