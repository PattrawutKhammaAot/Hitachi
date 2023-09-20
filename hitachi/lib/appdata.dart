import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static setMode(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("Mode", value);
  }

  static dynamic getMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("Mode");
    return value;
  }
}
