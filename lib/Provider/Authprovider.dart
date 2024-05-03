import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo_note_app/model/LoginResponse.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/model/UserDetail.dart';
import 'package:memo_note_app/view/Screen/Homepage.dart';
import 'package:memo_note_app/view/Screen/auth/OTPVerificationScreen.dart';
import '../utils/share_preferrences.dart';

class AuthProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseURl = 'http://192.168.42.165:8080/api/memo/notes/Auth/';
  bool _isLoading = false;
  String? _errorMessage;
  bool _iscountdownstarted = false;
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
  Future<void> loginAcc(
      String email, String password, BuildContext context) async {
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

          // // Fetch user data
          // final user = await _getUserData(loginResponse.accessToken!);

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageScreen(user: User(email: email)),
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
        throw Exception(
            'Login failed: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Login error: $error');
      throw Exception('An error occurred during login: $error');
    }
  }

  // Future<User> _getUserData(String token) async {
  //   final userProvider = AuthProvider();
  //   return await userProvider._getUserData(token);
  // }

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

  Future<UserDetail?> getUserByEmailAndPassword(
      String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${_baseURl}findUserMatchPassword?email=$email&password=$password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 404) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        print('Email or Password is Incorrect');
        return null;
      }
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        UserDetail user = UserDetail.fromJson(jsonResponse['payload']);
        return user;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      return null; // An error occurred
    }
  }

  Future<bool> isEmailregistered(String email) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseURl}findUserEmail?email=$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        print(user);
        return user != null;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  //check OTP
  Future<String> findOTP(String otp) async {
    final response = await http.get(
      Uri.parse('${_baseURl}findOTP?otp=$otp'),
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
        Uri.parse('${_baseURl}resend-otp?email=$email'),
      );
      if (response.statusCode == 200) {
        _iscountdownstarted = true;
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
}
