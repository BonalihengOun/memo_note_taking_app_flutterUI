import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/notePaper.dart';
import '../utils/share_preferrences.dart';

class NoteProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseURl = 'http://192.168.42.165:8080/api/memo/notes/';
  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<List<Notepaper>> getAllNote() async {
    try {
      final token = await _prefs.getTokenFromPrefs();
      if (token == null) {
        throw Exception('Access token is null');
      }
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      // Make the API call
      final response = await http.get(
        Uri.parse(_baseURl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<Notepaper> notePapers =
            jsonResponse.map((json) => Notepaper.fromJson(json)).toList();
        // Convert each JSON object to a Notepaper object
        return notePapers;
      } else {
        print('Error fetching data: ${response.statusCode}');
        throw Exception('Failed to load notes: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw Exception('Failed to load notes: $error');
    }
  }
}
