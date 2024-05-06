import 'package:memo_note_app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Share_preferences {
  // Save token and username to SharedPreferences
  Future<void> saveUserDataToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }


  // Retrieve token from SharedPreferences
  Future<String?> getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Retrieve username from SharedPreferences
  Future<String?> getUsernameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Remove token and username from SharedPreferences
  Future<void> removeTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('username');
  }

  // Example usage in logout method
  Future<void> logout() async {
    await removeTokenFromPrefs();
  }

  // Check if token exists in SharedPreferences
  Future<bool> hasTokenInPrefs() async {
    final token = await getTokenFromPrefs();
    return token != null;
  }
}
