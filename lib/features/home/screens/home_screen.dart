import 'package:client/signals/user_signal.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Watch((context) {
        final user = userSignal.value;
        return Text(user?.name ?? 'No user');
      }),
    ));
  }
}
