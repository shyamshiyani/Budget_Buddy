import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static const String _isFirstTimeKey = 'isFirstTime';

  Future<bool> checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setUserHasStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeKey, false);
  }
}
