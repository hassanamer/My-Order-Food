import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/widgets/welcome_splash_widget.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/home/order_food_home_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/onborading_widgets/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      onboardingImage: 'assets/images/download.gif',
      text: 'Welcome to Food Together',
      desc:
          'Discover a smarter way to order food \nwith your colleagues. Join forces to place orders, \nshare responsibilities, and save time. Let’s make lunchtime seamless and efficient!',
      background: Colors.white,
      button: const Color(0xFFf5b358),
    ),
    OnboardModel(
      onboardingImage: 'assets/images/download2.gif',
      text: 'Coordinate Effortlessly',
      desc:
          'Work together by coordinating orders with your team. One person calls the restaurant, another picks it up at the gate. Share the load and enjoy your meal with ease.',
      background: const Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      onboardingImage: 'assets/images/download1.gif',
      text: 'Enjoy and Save Time',
      desc:
          'With everyone playing a part, food ordering becomes a breeze. Save time, reduce hassle, and enjoy delicious meals without the wait. Let’s get started!',
      background: Colors.white,
      button: const Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    print('Shared pref called');
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          const OrderFoodHomePage()));
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: kblack,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200.h,
                    child: Image.asset(
                      screens[index].onboardingImage,
                      width: MediaQuery.of(context)
                          .size
                          .width, // Full screen width
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                width: currentIndex == index ? 25 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? kbrown
                                      : kbrown300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: kblack,
                    ),
                  ),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      color: kblack,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      print(index);
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const WelcomeSplashWidget()));
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: kblue,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Next',
                              style: TextStyle(fontSize: 16.0, color: kwhite),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Icon(
                              Icons.arrow_forward_sharp,
                              color: kwhite,
                            )
                          ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
