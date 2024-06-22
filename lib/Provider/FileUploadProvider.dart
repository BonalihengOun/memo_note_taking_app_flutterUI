



import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/share_preferrences.dart';

class FileUploadProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseUrl = 'http://192.168.41.143:8080/api/v1/files/';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Future<String?> getFileUrlByFileName(String filename) async {
  //   final token = await _prefs.getTokenFromPrefs();
  //   if (token == null) {
  //     throw Exception('Access token is null');
  //   }
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   final response = await http.get(
  //     Uri.parse(_baseUrl + filename),
  //     headers: headers,
  //   );
  //   if (response.statusCode == 200) {
  //     final jsonResponse = response.body;
  //     final imageUrl = // Parse the image URL from jsonResponse
  //     return imageUrl;
  //   } else {
  //     print('Failed to Download File. Status code: ${response.statusCode}');
  //     throw Exception('Failed to Download File. Status code: ${response.statusCode}');
  //   }
  // }

}