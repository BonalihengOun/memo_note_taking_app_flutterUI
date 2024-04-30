import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Share_preferences {

  // Save token to SharedPreferences
  Future<void> saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  // Retrieve token from SharedPreferences
  Future<String?> getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Remove token from SharedPreferences
  Future<void> removeTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

// Example usage in logout method
  Future<void> logout() async {
    await removeTokenFromPrefs();
  }
  Future<bool> hasTokenInPrefs() async {
    final token = await getTokenFromPrefs();
    return token != null;
  }



}