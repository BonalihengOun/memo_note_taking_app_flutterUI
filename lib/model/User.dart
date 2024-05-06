// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  int? userId;
  String? username;
  String? email;
  String? password;
  String? confirmPassword;

  User({
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'], // Corrected typo in key name
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword, // Corrected typo in key name
    };
  }
}
