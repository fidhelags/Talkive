import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_session.dart';

class LoginResult {
  final bool success;
  final String? message;
  final bool isTutorAccount;

  const LoginResult({
    required this.success,
    this.message,
    this.isTutorAccount = false,
  });
}

class RegisterResult {
  final bool success;
  final String message;

  const RegisterResult({required this.success, required this.message});
}

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        UserSession.instance.setUser(
          id: data['id'] as int,
          name: data['name'] as String,
          email: data['email'] as String,
          preferredLanguage: data['preferredLanguage'] as String?,
        );
        return const LoginResult(success: true);
      }

      if (response.statusCode == 403 && data['code'] == 'tutor_use_website') {
        return LoginResult(
          success: false,
          isTutorAccount: true,
          message: data['message'] as String?,
        );
      }

      return LoginResult(
        success: false,
        message: data['message'] as String? ?? 'Email atau password salah.',
      );
    } catch (_) {
      return const LoginResult(
        success: false,
        message: 'Gagal terhubung ke server. Periksa koneksi internet.',
      );
    }
  }

  static Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return RegisterResult(
        success: response.statusCode == 200 && data['success'] == true,
        message: data['message'] as String? ?? 'Terjadi kesalahan.',
      );
    } catch (_) {
      return const RegisterResult(
        success: false,
        message: 'Gagal terhubung ke server. Periksa koneksi internet.',
      );
    }
  }

  /// Hapus sesi lokal.
  static void logout() => UserSession.instance.clear();
}
