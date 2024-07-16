import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 207, 78, 27);
const Color headline1Color = Color.fromRGBO(0, 76, 255, 1);
const secondaryColor = Color.fromARGB(255, 8, 0, 0);
const Color onBoardingIndcatorColor = Color.fromRGBO(229, 229, 229, 1);
const Color authTextFromFieldHintTextColor = Color.fromRGBO(194, 189, 189, 1);
const Color authTextFromFieldPorderColor = Color.fromRGBO(214, 218, 225, 1);
const Color authTextFromFieldFillColor = Color.fromRGBO(241, 244, 254, 1);
const Color authTextFromFieldErrorBorderColor =
    Color.fromRGBO(204, 151, 151, 1);
final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    iconTheme: IconThemeData(color: secondaryColor),
    centerTitle: true,
  ),
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: secondaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: authTextFromFieldFillColor.withOpacity(.3),
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
      floatingLabelStyle: const TextStyle(color: primaryColor),
      iconColor: secondaryColor,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(12),
      )),
);
