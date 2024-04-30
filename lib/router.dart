import 'package:client/features/auth/screens/login_screen.dart';
import 'package:client/features/auth/screens/signup_screen.dart';
import 'package:client/features/home/screens/home_screen.dart';
import 'package:client/models/user_model.dart';
import 'package:flutter/material.dart';

Route router(RouteSettings settings, User? user) {
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) {
      switch (settings.name) {
        case SignupScreen.routeName:
          return const SignupScreen();
        case HomeScreen.routeName:
          return const HomeScreen();
        case LoginScreen.routeName:
          return const LoginScreen();
        default:
          return user == null ? const LoginScreen() : const HomeScreen();
      }
    },
  );
}
