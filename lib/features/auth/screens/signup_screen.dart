import 'package:client/base_client.dart';
import 'package:client/features/auth/widgets/auth_text_field.dart';
import 'package:client/models/user_model.dart';
import 'package:client/signals/user_signal.dart';
import 'package:crypton/crypton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  void handleSignup() async {
    final keypair = RSAKeypair.fromRandom();
    BaseClient response = await BaseClient.post(
      data: {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'publicKey': keypair.publicKey.toPEM(),
        'name': _nameController.text.trim(),
      },
      path: '/signup',
    );
    if (response.success) {
      User user = User.fromMap(response.data as Map<String, dynamic>);
      userSignal.set(user);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      debugPrint(user.toString());
    } else {
      debugPrint(response.error.toString());
    }
  }

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
              'Sign Up',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            AuthTextField(
              controller: _nameController,
              hintText: 'Name',
            ),
            const SizedBox(height: 10),
            AuthTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 10),
            AuthTextField(
              controller: _passwordController,
              hintText: 'Password',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: handleSignup,
              child: const Text(
                'Sign Up',
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
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      text: 'Login',
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
