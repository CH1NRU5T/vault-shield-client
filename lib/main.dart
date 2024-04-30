import 'package:client/core/app_palette.dart';
import 'package:client/models/user_model.dart';
import 'package:client/router.dart';
import 'package:client/signals/user_signal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userJson = prefs.getString('user');
  User? user;
  if (userJson != null) {
    user = User.fromJson(userJson);
  }
  userSignal.set(user);
  runApp(MyApp(
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vault Shield',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppPallete.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppPallete.backgroundColor,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppPallete.borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppPallete.gradient2, width: 2),
          ),
        ),
      ),
      onGenerateRoute: (settings) => router(settings, user),
    );
  }
}
