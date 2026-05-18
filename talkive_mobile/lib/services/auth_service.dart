import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthResult {
  AuthResult({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
}

class AuthService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN BODY: ${response.body}');

      return response.statusCode == 200;
    } catch (error) {
      print('LOGIN ERROR: $error');
      return false;
    }
  }

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER BODY: ${response.body}');

      final body = jsonDecode(response.body);

      return AuthResult(
        success: response.statusCode == 200,
        message: body['message'] ?? 'Terjadi kesalahan',
      );
    } catch (error) {
      print('REGISTER ERROR: $error');

      return AuthResult(
        success: false,
        message: 'Gagal terhubung ke server',
      );
    }
  }
}