import 'package:flutter_session_manager/flutter_session_manager.dart';

class LoginState {
  static bool? isLogin = false;
  static SessionManager preferences = SessionManager();

  static Future<bool> get checkLogin async {
    isLogin = await preferences.get("login");
    
    return Future.value(isLogin ?? false);
  }

  static Future<void> get login async {
    preferences.set("login", true);
    isLogin = true;
  }

  static Future<void> get logout async {
    preferences.set("login", false);
    isLogin = false;
  }
}
