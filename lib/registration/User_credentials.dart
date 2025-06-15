import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserCredentials {
  static final Map<String, String> _userCredentials = {};
  static final Map<String, String> _userEmails = {};
  static const _storage = FlutterSecureStorage();

  static final Map<String, List<bool?>> _userRecommendations = {};

  // Save answers
  static Future<void> saveRecommendationAnswers(String username, List<bool?> answers) async {
    _userRecommendations[username] = answers;
    await _storage.write(key: 'recommendations_$username', value: answers.join(','));
  }

  // Load answers
  static Future<List<bool?>?> getRecommendationAnswers(String username) async {
    final saved = await _storage.read(key: 'recommendations_$username');
    return saved?.split(',').map((e) => e == 'true' ? true : (e == 'false' ? false : null)).toList();
  }

// Add user with email
  static Future<void> addUser(String username, String password, {String? email}) async {
    _userCredentials[username] = password;
    if (email != null) {
      _userEmails[username] = email;
      await _storage.write(key: 'email_$username', value: email);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await _storage.write(key: 'password', value: password);
    if (email != null) {
      await _storage.write(key: 'email_$username', value: email);
    }
  }

  // Validate credentials
  static bool validateCredentials(String username, String password) {
    return _userCredentials[username] == password;
  }

  // Check if email exists
  static bool emailExists(String email) {
    return _userEmails.containsValue(email);
  }

  // Get username by email
  static String? getUsernameByEmail(String email) {
    return _userEmails.keys.firstWhere(
          (key) => _userEmails[key] == email,
      orElse: () => '',
    );
  }

  // Reset password
  static Future<bool> resetPassword(String email, String newPassword) async {
    final username = getUsernameByEmail(email);
    if (username != null && username.isNotEmpty && _userCredentials.containsKey(username)) {
      await addUser(username, newPassword);
      return true;
    }
    return false;
  }

  // Load saved credentials
  static Future<void> loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      if (username != null) {
        final password = await _storage.read(key: 'password');
        final email = await _storage.read(key: 'email_$username');

        if (password != null) {
          _userCredentials[username] = password;
        }
        if (email != null) {
          _userEmails[username] = email;
        }
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }

  // Clear saved credentials
  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await _storage.delete(key: 'password');
  }
}