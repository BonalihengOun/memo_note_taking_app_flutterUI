import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo_note_app/model/LoginResponse.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/model/userResponse.dart';

import 'package:memo_note_app/view/Screen/auth/OTPVerificationScreen.dart';
import '../utils/share_preferrences.dart';
import '../view/Screen/auth/login_screen.dart';

class AuthProvider with ChangeNotifier {
  final Share_preferences _prefs = Share_preferences();
  final String _baseURl = 'http://192.168.42.162:8080/api/memo/notes/Auth/';
  bool _isLoading = false;
  late final String? email;
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
            builder: (context) => OTPVerificationScreen(email: user.email)),
      );
    }
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final RegisterResponse = User.fromJson(data);
      print('UserId: ${RegisterResponse.userId}');
      print('Username: ${RegisterResponse.username}');
      print('email: ${RegisterResponse.email}');
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
  Future<bool> loginAcc(
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
        print('userId:${loginResponse.userId}');
        print('userName:${loginResponse.username}');
        print('email:${loginResponse.email}');
        print('accessToken: ${loginResponse.accessToken}');

        if (loginResponse.accessToken != null) {
          await _prefs.saveUserDataToPrefs(
              loginResponse.accessToken!); // Pass email and username
          return true; // Login successful
        } else {
          print('Error: accessToken is null');
          throw Exception('Access token is null');
        }
      } else if (response.statusCode == 404) {
        // Handle incorrect password
        print('Incorrect password');
        return false; // Incorrect password
      } else if (response.statusCode == 400) {
        // Handle invalid email
        print('Please Verify your Email, We sent an OTP on your email address');
        await resendOTP(email, context);
        return false; // Invalid email
      } else {
        throw Exception(
            'Login failed: ${response.statusCode}, ${response.reasonPhrase}');
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

  // ForgetPassword - Request OTP with error handling and user feedback
  Future<bool> requestOTP(String email, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseURl}forget-password/request-otp/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _errorMessage = response.reasonPhrase ?? 'Failed to request OTP';
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      return false;
    }
  }

  // ForgetPassword - Verify OTP and reset password
  Future<bool> verifyOtpAndResetPassword(String email,
      String password, String confirmPassword, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('${_baseURl}forget-password/verify-otp/$email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      return false;
    }
  }

  //Verify OTP forgot password
  Future<bool> verifyOTPForgotPassword(
      String otpCode, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseURl}forget-password/verify-otp/$otpCode'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return data; // Assuming the response is a boolean
      } else {
        _errorMessage = 'Failed to verify OTP';
        notifyListeners();
        print(_errorMessage);
        return false;
      }
    } catch (error) {
      print(error);
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
      return false;
    }
  }

  // User change Name
  Future<bool> changeUsername(String newUsername, BuildContext context) async {
    try {
      final token = await _prefs.getTokenFromPrefs(); // Assuming _prefs is already defined and initialized
      if (token == null) {
        throw Exception('Access token is null');
      }
      final response = await http.put(
        Uri.parse('${_baseURl}changeUsername/$newUsername'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        final responseBody = json.decode(response.body);
        _errorMessage = responseBody['message'] ?? 'Failed to change username';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      return false;
    }
  }

  //Reset Password
  Future<bool> resetPassword(String? email, String password, String confirmPassword, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('${_baseURl}reset-password/$email'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final responseBody = json.decode(response.body);
        _errorMessage = responseBody['message'] ?? 'Failed to reset password';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      return false;
    }
  }

  // Get Username and Email
  Future<UserResponse> getUserDetails() async {
    try {
      final token = await _prefs.getTokenFromPrefs(); // Assuming _prefs is already defined and initialized
      if (token == null) {
        throw Exception('Access token is null');
      }
      final response = await http.get(
        Uri.parse('${_baseURl}getUserDetails'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final userResponse = UserResponse.fromJson(responseBody);
        print('userId: ${userResponse.userId}');
        print('name: ${userResponse.name}');
        print('email: ${userResponse.email}');
        notifyListeners();
        return userResponse;
      } else {
        throw Exception('Failed to get user data: ${response.statusCode}');
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
      throw error;
    }
  }


}
