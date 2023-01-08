import 'package:shared_preferences/shared_preferences.dart';

class LoginState {
  static bool? isLogin = false;

  static Future<bool> get checkLogin async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLogin = preferences.getBool("login");
    return Future.value(isLogin);
  }

  static Future<void> get login async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("login", true);
    isLogin = true;
  }

  static Future<void> get logout async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("login", false);
    isLogin = false;
  }
}
