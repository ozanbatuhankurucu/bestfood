import 'package:shared_preferences/shared_preferences.dart';

class Token  {
  

 static Future<dynamic> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  return token;
}
  static addUserToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
}
static resetUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', null);
}
}