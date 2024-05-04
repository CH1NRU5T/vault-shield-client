import 'dart:convert';

import 'package:http/http.dart' as http;

class BaseClient {
  final Map<String, dynamic>? data;
  final String? error;
  final bool success;
  // static const String baseUrl = 'http://127.0.0.1:8080';
  static const String baseUrl = 'https://scsvt5nk-8080.inc1.devtunnels.ms';
  // static const String baseUrl =
  //     'http://vault-shield-server-8f0c-jegchat-ch1nru5t.globeapp.dev';
  BaseClient({
    this.data,
    this.error,
    required this.success,
  });
  static Future<BaseClient> get({
    required String path,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: {
          ...?headers,
          'Content-Type': 'application/json',
          'Accept': '*/*',
          "Access-Control-Allow-Origin": "*"
        },
      );
      if (response.statusCode == 200) {
        return BaseClient(
          data: jsonDecode(response.body),
          success: true,
        );
      } else {
        return BaseClient(
          error: response.body,
          success: false,
        );
      }
    } catch (e) {
      return BaseClient(
        error: e.toString(),
        success: false,
      );
    }
  }

  static Future<BaseClient> post({
    required Map<String, dynamic> data,
    required String path,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        body: jsonEncode(data),
        headers: {
          ...?headers,
          'Content-Type': 'application/json',
          'Accept': '*/*',
          "Access-Control-Allow-Origin": "*"
        },
      );
      if (response.statusCode == 200) {
        return BaseClient(
          data: jsonDecode(response.body),
          success: true,
        );
      } else {
        return BaseClient(
          error: response.body,
          success: false,
        );
      }
    } catch (e) {
      return BaseClient(
        error: e.toString(),
        success: false,
      );
    }
  }
}
