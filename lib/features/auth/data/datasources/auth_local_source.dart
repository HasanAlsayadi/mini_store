import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for auth — persists login state
class AuthLocalSource {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _loginMethodKey = 'login_method';
  static const String _userIdentifierKey = 'user_identifier';

  final SharedPreferences prefs;

  const AuthLocalSource(this.prefs);

  Future<void> saveLoginState({
    required String method,
    required String identifier,
  }) async {
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_loginMethodKey, method);
    await prefs.setString(_userIdentifierKey, identifier);
  }

  bool isLoggedIn() {
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  String? getLoginMethod() {
    return prefs.getString(_loginMethodKey);
  }

  String? getUserIdentifier() {
    return prefs.getString(_userIdentifierKey);
  }

  Future<void> clearLoginState() async {
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_loginMethodKey);
    await prefs.remove(_userIdentifierKey);
  }
}
