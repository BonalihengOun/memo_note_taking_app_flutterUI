import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/view/Screen/auth/OTPVerificationScreen.dart';

class AuthProvider with ChangeNotifier {
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
      Uri.parse('http://192.168.52.143:8080/api/memo/notes/Auth/register'),
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

  //Verify-Otp
  Future<bool> verifyOTP(String otpCode, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.52.143:8080/api/memo/notes/Auth/verify-otp'),
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
          'http://192.168.52.143:8080/api/memo/notes/Auth/findUserEmail?email=$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final emailUser = jsonDecode(response.body);
      print(emailUser);
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
          'http://192.168.52.143:8080/api/memo/notes/Auth/findOTP?otp=$otp'),
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
            'http://192.168.52.143:8080/api/memo/notes/Auth/resend-otp?email=$email'),
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
}
