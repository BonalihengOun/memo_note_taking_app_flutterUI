import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_email_validator/email_validator.dart';
import 'package:memo_note_app/Provider/Authprovider.dart';
import 'package:memo_note_app/model/User.dart';

import 'package:memo_note_app/view/Screen/auth/login_screen.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  // Renamed class to Register
  const Register({Key? key}) : super(key: key); // Added missing Key parameter

  @override
  State<Register> createState() =>
      _RegisterState(); // Corrected class name in State
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF610AA5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: Image.asset('lib/assets/Memo..png',
                    width: 140, height: 50, alignment: Alignment(5, 15)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 160, left: MediaQuery.of(context).size.width * 0.08),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NiraBold',
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.08),
                  child: const Text(
                    'Create your own account to get start taking note',
                    style: TextStyle(
                      color: Color(0xFFFFC839),
                      fontFamily: 'NiraSemi',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            //Username
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 20, left: 20, right: 20),
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 1.5,
                                        color: Color(
                                          0xFFFFC839,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  errorStyle: const TextStyle(
                                    fontFamily: 'NiraRegular',
                                    color: Color(
                                      0xFFFFC839,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(width: 1)),
                                  hintText: 'Username',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'NiraRegular'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: const Icon(Icons.person,
                                        color: Colors.grey),
                                  ),
                                  prefixIconConstraints:
                                      BoxConstraints(minWidth: 20),
                                  suffixIconConstraints:
                                      BoxConstraints(minWidth: 40),
                                  prefixStyle: TextStyle(
                                    color: _usernameController.text.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            //Email
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 20, left: 20, right: 20),
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.5,
                                        color: Color(
                                          0xFFFFC839,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  errorStyle: TextStyle(
                                    fontFamily: 'NiraRegular',
                                    color: Color(
                                      0xFFFFC839,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'NiraRegular'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: const Icon(Icons.email,
                                        color: Colors.grey),
                                  ),
                                  prefixIconConstraints:
                                      BoxConstraints(minWidth: 20),
                                  suffixIconConstraints:
                                      BoxConstraints(minWidth: 40),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (!EmailValidator.validate(value ?? "")) {
                                    return 'Please enter an Email';
                                  } else if (!_emailController.text
                                      .contains('@gmail.com')) {
                                    return 'Please enter a valid Gmail address';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            //Password
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _passwordObscureText,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 10, bottom: 20, left: 20, right: 20),
                                  focusColor: Colors.amber,
                                  filled: true,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Color(0xFFFFC839),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  errorStyle: TextStyle(
                                    fontFamily: 'NiraRegular',
                                    color: Color(0xFFFFC839),
                                  ),
                                  errorMaxLines: 3,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'NiraRegular',
                                  ),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordObscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordObscureText =
                                            !_passwordObscureText;
                                      });
                                    },
                                  ),
                                  prefixIconConstraints:
                                      BoxConstraints(minWidth: 18),
                                  suffixIconConstraints:
                                      BoxConstraints(minWidth: 40),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (!RegExp(
                                          r"^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[@#$%^&+=!])(?=\S+$).{8,}$")
                                      .hasMatch(value)) {
                                    return 'Password must be at least 8 characters long and contain at least one number, one letter, and one special character.';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Changed function call to match renamed function
                            SizedBox(
                              height: 15,
                            ),
                            //ConfirmPassword
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _confirmPasswordObscureText,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 20, left: 20, right: 20),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.5,
                                        color: Color(
                                          0xFFFFC839,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: const TextStyle(
                                    fontFamily: 'NiraRegular',
                                    color: Color(
                                      0xFFFFC839,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Confirm Password',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'NiraRegular'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _confirmPasswordObscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _confirmPasswordObscureText =
                                            !_confirmPasswordObscureText;
                                      });
                                    },
                                  ),
                                  prefixIconConstraints:
                                      BoxConstraints(minWidth: 18),
                                  suffixIconConstraints:
                                      BoxConstraints(minWidth: 40),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) => value!.isEmpty ||
                                        value != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                              ),
                            ), // Changed function call to match renamed
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Set border radius here
                                  ),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.88,
                                      MediaQuery.of(context).size.height *
                                          0.054),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // If form validation succeeds, create a User object
                                    User user = User(
                                      username: _usernameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      confirmPassword:
                                          _confirmPasswordController.text,
                                    );

                                    String userData = jsonEncode(user.toJson());
                                    print(userData);

                                    try {
                                      final isEmailRegistered =
                                          await registerProvider
                                              .isEmailregistered(
                                                  _emailController.text);

                                      if (!isEmailRegistered) {
                                        registerProvider.isLoading = true;
                                        await registerProvider.registerUser(
                                            user, context);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                backgroundColor: Colors
                                                    .transparent, // Set transparent background
                                                contentPadding: EdgeInsets.zero,
                                                content: Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        10), // Optional: Add border radius
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width: 250,
                                                          height: 200,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Image.asset('lib/assets/check.png',width: 60,height: 60,),
                                                              ),
                                                              Text('Successfull',style: TextStyle(fontFamily: 'NiraBold',fontSize: 20,color: Colors.amber),),
                                                              SizedBox(height: 10),
                                                              Center(child: Text('Your account has been created!!!',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 14,color: Colors.grey),)),
                                                              Text('Please check your email to activate your account',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 12,color: Colors.grey.shade500),),
                                                            ],
                                                          ),
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                            color: Colors.white,
                                                          ),

                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        );
                                        Navigator.pop(context);
                                        registerProvider.isLoading = false;
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                              false, // Prevent dialog from being dismissed
                                          builder: (BuildContext context) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5,
                                              strokeCap: StrokeCap
                                                  .round, // Adjust the strokeWidth to control the radius
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                              semanticsLabel: 'Loading',
                                              semanticsValue: '20%',
                                            ),
                                          ),
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        Navigator.pop(context);
                                        showCustomAlertDialog(context, 'Warning', 'Email already registered!!!','Please use a different email.', imagePath: 'lib/assets/warning.png');
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        Navigator.pop(context);
                                      }
                                    } catch (error) {
                                      print(error);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Text("Error!"),
                                          content: Text(
                                              "An error occurred during registration."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NiraBold',
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an Account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NiraRegular',
                                      fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    ); // Go back to the previous screen (LoginScreen)
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Color(0xFFFFC839),
                                      fontFamily: 'NiraBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (registerProvider.isLoading)
                              Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  strokeCap: StrokeCap
                                      .round, // Adjust the strokeWidth to control the radius
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  semanticsLabel: 'Loading',
                                  semanticsValue: '20%',
                                ),
                              ),
                            if (registerProvider.errorMessage != null)
                              Text(
                                registerProvider.errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from being dismissed
    builder: (BuildContext context) => AlertDialog(
      content: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          strokeCap: StrokeCap.round,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          semanticsLabel: 'Loading',
          semanticsValue: '20%',
        ),
      ),
    ),
  );
}

void showCustomAlertDialog(BuildContext context, String title, String message, String description, {String? imagePath}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.transparent, // Set transparent background
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Optional: Add border radius
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 250,
                height: 200,
                child: Column(
                  children: [
                    if (imagePath != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(imagePath, width: 60, height: 60),
                      ),
                    Text(
                      title,
                      style: TextStyle(fontFamily: 'NiraBold', fontSize: 20, color: Colors.amber),
                    ),
                    SizedBox(height: 10),
                    Center(child: Text(message, style: TextStyle(fontFamily: 'NiraRegular', fontSize: 14, color: Colors.black54))),
                    SizedBox(height: 5,),
                    Text(description, style: TextStyle(fontFamily: 'NiraRegular', fontSize: 12, color: Colors.black54)),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}