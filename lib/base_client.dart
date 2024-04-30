import 'dart:convert';

import 'package:http/http.dart' as http;

class BaseClient {
  final Map<String, dynamic>? data;
  final String? error;
  final bool success;
  // final String baseUrl = 'http://10.0.2.2:8080';
  static const String baseUrl = 'https://scsvt5nk-8080.inc1.devtunnels.ms';
  BaseClient({
    this.data,
    this.error,
    required this.success,
  });
  static Future<BaseClient> post({
    required Map<String, dynamic> data,
    required String path,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
