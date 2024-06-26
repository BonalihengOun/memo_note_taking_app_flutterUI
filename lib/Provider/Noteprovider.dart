import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo_note_app/model/notepaperRequest.dart';
import '../model/notePaper.dart';
import '../utils/share_preferrences.dart';

class NoteProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseUrl = 'http://192.168.42.162:8080/api/memo/notes/';
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
            final List<Notepaper> notePapers =
                payload.map((json) => Notepaper.fromJson(json)).toList();
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

  Future<void> createNote(NotepaperRequest note) async {
    try {
      final token = await _prefs.getTokenFromPrefs();
      if (token == null) {
        throw Exception('Access token is null');
      }
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(note.toMap()),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        print("Response: $jsonResponse");
        print('Note created successfully');
      } else {
        print('Failed to create note. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create note');
      }
    } catch (error) {
      print('Error creating note: $error');
      throw Exception('Failed to create note: $error');
    }
  }

  Future<bool> deleteNote(String id) async {
    try {
      final token = await _prefs.getTokenFromPrefs();
      if (token == null) {
        throw Exception('Access token is null');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.delete(
        Uri.parse('$_baseUrl$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.body;
        print("Response: $jsonResponse");
        print('Note Delete successfully');
        return true;
      } else if (response.statusCode == 404) {
        print('Note with Id $id does not exist.: ${response.statusCode}');
        return false;
      } else {
        print('Failed to Delete Note. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete note');
      }
    } catch (error) {
      print('Error Delete Note: $error');
      throw Exception('Failed to delete note: $error');
    }
  }

  Future<Notepaper> updateNotebyId(
      NotepaperRequest notepaperRequest, String id) async {
    try {
      final token = await _prefs.getTokenFromPrefs();
      if (token == null) {
        throw Exception('Access token is null');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.put(
        Uri.parse('$_baseUrl$id'),
        headers: headers,
        body: jsonEncode(notepaperRequest.toMap()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("Response: $jsonResponse");
        print('Note updated successfully');
        return Notepaper.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        print(
            'Note with Id $id does not exist. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update note: Note not found');
      } else if (response.statusCode == 401) {
        print('Unauthorized. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update note: Unauthorized');
      } else {
        print('Failed to update note. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update note');
      }
    } catch (error) {
      print('Error updating note: $error');
      throw Exception('Failed to update note: $error');
    }
  }

  Future<List<Notepaper>> filterNotedBytitle(String title) async {
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
        Uri.parse(_baseUrl + 'title/' + title),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print("Response: $jsonResponse");
        print('Note found successfully');

        final List<Notepaper> notePapers =
            jsonResponse.map((json) => Notepaper.fromJson(json)).toList();
        return notePapers;
      } else {
        print('Failed to find note. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error finding note data: $error');
      throw Exception('Failed to finding notes: $error');
    }
  }
}
