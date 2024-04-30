import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo_note_app/model/LoginResponse.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/view/Screen/Homepage.dart';
import 'package:memo_note_app/view/Screen/auth/OTPVerificationScreen.dart';
import '../utils/share_preferrences.dart';

class AuthProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseURl = 'http://192.168.191.143:8080/api/memo/notes/Auth/';
  bool _isLoading = false;
  String? _errorMessage;

  bool _registrationSuccessful = false;

  bool get registrationSuccessful => _registrationSuccessful;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Register acc
  Future<void> registerUser(User user, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    _registrationSuccessful = false; // Reset flag
    notifyListeners();

    final response = await http.post(
      Uri.parse("${_baseURl}register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    void onRegistrationSuccessful(BuildContext context) {
      _registrationSuccessful = true; // Set flag on success
      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(user: user)),
      );
    }

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print(data);
      print('User registration successful!');
      onRegistrationSuccessful(context);
    } else {
      _errorMessage = response.reasonPhrase;
      print('Registration failed: ${response.statusCode}');
    }
    _isLoading = false;
    notifyListeners();
  }

  //Login Account user
  Future<void> loginAcc(String email, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseURl}login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseBody);

        print('Response body: $loginResponse');
        print('accessToken: ${loginResponse.accessToken}');

        if (loginResponse.accessToken != null) {
          print('Login successful!');
          // Save token to SharedPreferences
          await _prefs.saveTokenToPrefs(loginResponse.accessToken!);
          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageScreen(
                user: User(
                  email: email, // Assuming loginResponse has email property
                  // Other user properties...
                ),
              ),
            ),
          );

        } else {
          print('Error: accessToken is null');
          throw Exception('Access token is null');
        }
      } else if (response.statusCode == 401) {
        // Handle incorrect password
        print('Incorrect password');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Incorrect password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Login failed: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Login error: $error');
      throw Exception('An error occurred during login: $error');
    }
  }




  //Verify-Otp
  Future<bool> verifyOTP(String otpCode, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('${_baseURl}verify-otp'),
        body: {'otpCode': otpCode},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        return true;
      } else {
        print(_errorMessage);
        return false;
      }
    } catch (error) {
      print(error);
      _errorMessage = 'An error occurred: $error';
      return false;
    } finally {
      notifyListeners();
    }
  }

//Check if email already Register
  Future<bool> isEmailRegistered(String email) async {
    final response = await http.get(
      Uri.parse(
          '${_baseURl}findUserEmail?email=$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      print(user);
      print(user['email']);
      print(user['password']);
      return true;
    } else {
      // Email is not registered
      return false;
    }
  }

  //check OTP
  Future<String> findOTP(String otp) async {
    final response = await http.get(
      Uri.parse(
          '${_baseURl}findOTP?otp=$otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final OTP = jsonDecode(response.body);
      print(OTP);
      return 'Get OTP Successfully';
    } else {
      return 'Failed to get OTP';
    }
  }

  //ResendOTP
  Future<void> resendOTP(String email, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${_baseURl}resend-otp?email=$email'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('A new OTP has successfully.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while resending OTP.'),
        ),
      );
    }
  }

  Future<void> fetchData() async {
    final token = await _prefs.getTokenFromPrefs();
    // Construct request headers with the access token
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('http://192.168.191.143:8080/api/memo/notes'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

}
