import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:memo_note_app/model/tag.dart';
import 'package:http/http.dart' as http;
import '../utils/share_preferrences.dart';

class TagProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseUrl = 'http://192.168.70.143:8081/api/memo/tags/';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<List<Tag>> getAllTags() async {
    try {
      final token = await _prefs.getTokenFromPrefs();
      if (token == null) {
        throw Exception('Access token is null');
      }
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        print("Response: $jsonResponse");
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('payload')) {
          final List<dynamic>? payload = jsonResponse['payload'];

          if (payload != null) {
            final List<Tag> notePapers =
                payload.map((json) => Tag.fromJson(json)).toList();
            return notePapers;
          } else {
            print('Invalid payload in JSON response: $jsonResponse');
            throw Exception('Invalid payload in JSON response');
          }
        } else {
          print('Invalid JSON response: $jsonResponse');
          throw Exception('Invalid JSON response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw Exception('Failed to load notes: $error');
    }
  }

}
