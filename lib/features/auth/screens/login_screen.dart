import 'dart:convert';

import 'package:client/base_client.dart';
import 'package:client/features/auth/widgets/auth_text_field.dart';
import 'package:client/models/user_model.dart';
import 'package:client/signals/user_signal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            AuthTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            AuthTextField(
              controller: _passwordController,
              hintText: 'Password',
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () async {
                BaseClient response = await BaseClient.post(
                  data: {
                    'email': _emailController.text.trim(),
                    'password': _passwordController.text.trim(),
                  },
                  path: '/login',
                );
                if (response.success) {
                  debugPrint(response.data.toString());
                  User user =
                      User.fromMap(response.data as Map<String, dynamic>);
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('user', user.toJson());
                  userSignal.set(user);
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                  debugPrint(user.toString());
                } else {
                  debugPrint(response.error.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(jsonDecode(response.error!)['error']),
                    ),
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
