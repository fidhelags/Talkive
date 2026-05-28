import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyUserId = 'userId';
  static const _keyUserName = 'userName';
  static const _keyUserEmail = 'userEmail';

  static Future<void> saveSession({
    required int userId,
    required String userName,
    required String userEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserName, userName);
    await prefs.setString(_keyUserEmail, userEmail);
  }

  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_keyUserId);
    if (userId == null) return null;
    return {
      'userId': userId,
      'userName': prefs.getString(_keyUserName) ?? '',
      'userEmail': prefs.getString(_keyUserEmail) ?? '',
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
