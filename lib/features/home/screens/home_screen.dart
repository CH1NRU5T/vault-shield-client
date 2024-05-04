import 'package:client/base_client.dart';
import 'package:client/models/password_model.dart';
import 'package:client/signals/passwords_signal.dart';
import 'package:client/signals/user_signal.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint(userSignal.value!.token);
    loadPasswords(userSignal.value!.token);
  }

  void loadPasswords(String token) async {
    BaseClient client = await BaseClient.get(
        path: '/passwords', headers: {'Authorization': 'Bearer $token'});
    if (client.success) {
      List<Password> passwords = List<Password>.from(
        client.data?['passwords'].map(
          (password) => Password.fromMap(password),
        ),
      );
      passwordSignal.set(passwords);
    } else {
      debugPrint(client.error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Watch(
            (context) => Text('Welcome, ${userSignal.value?.name ?? 'User'}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
      body: Watch(
        (context) {
          List<Password> passwords = passwordSignal.value;
          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              Password password = passwords[index];
              return ListTile(
                title: Text(
                  password.website,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
