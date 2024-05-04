// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:client/models/user_model.dart';
import 'package:client/signals/user_signal.dart';
import 'package:crypton/crypton.dart';

class Password {
  // final String? id;
  final String password;
  final String username;
  final String website;
  // final String userId;
  Password({
    // this.id,
    required this.password,
    required this.username,
    required this.website,
    // required this.userId,
  });

  Password copyWith({
    // String? id,
    String? password,
    String? username,
    String? website,
    // String? userId,
  }) {
    return Password(
      // id: id ?? this.id,
      password: password ?? this.password,
      username: username ?? this.username,
      website: website ?? this.website,
      // userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'userId': userId,
      'password': password,
      'username': username,
      'website': website,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      // userId: map['userId'] as ObjectId,
      password: map['password'] as String,
      username: map['username'] as String,
      website: map['website'] as String,
    );
  }

  Password encrypt(Password password) {
    User user = userSignal.value!;
    if (user.publicKey != null) {
      final publicKey = RSAPublicKey.fromPEM(user.publicKey!);
      return Password(
        password: publicKey.encrypt(password.password),
        username: password.username,
        website: password.website,
      );
    }
    return password;
  }

  String toJson() => json.encode(toMap());

  factory Password.fromJson(String source) =>
      Password.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SavedPassword(password: $password, username: $username, website: $website)';
  }
}
