import 'package:flutter/material.dart';
import 'package:flutter_email_validator/email_validator.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:memo_note_app/view/Screen/Homepage.dart';

import 'package:memo_note_app/view/Screen/auth/registerscreen.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Authprovider.dart';
import '../../../model/User.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordObscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginAuthProvider = Provider.of<AuthProvider>(context);
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
                    'Login ',
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
                    'Hello!!! Welcome, Login to your account now :)',
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
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                          fontFamily: "NiraSemi",
                                          color: Colors.amber),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.88,
                                      MediaQuery.of(context).size.height *
                                          0.054),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final email = _emailController.text;
                                    final password = _passwordController.text;

                                    if (email.isNotEmpty &&
                                        password.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );

                                      try {
                                        final isEmailRegisteredResult =
                                            await loginAuthProvider
                                                .isEmailRegistered(email);

                                        if (isEmailRegisteredResult) {
                                          await Future.delayed(const Duration(
                                              seconds:
                                                  2)); // Show the circular progress indicator for 2 seconds
                                          Navigator.pop(
                                              context); // Dismiss the circular progress indicator
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              backgroundColor:
                                                  Colors.green.shade200,
                                              title: const Text("Success"),
                                              content: const Text(
                                                  "Your account is logged in successfully."),
                                            ),
                                          );
                                          await Future.delayed(const Duration(
                                              seconds:
                                              2));
                                          await loginAuthProvider.loginAcc(
                                              email, password, context);
                                        } else {
                                          Navigator.pop(
                                              context); // Dismiss the circular progress indicator
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              backgroundColor: Colors.red,
                                              title: Text(
                                                "Warning!",
                                                style: TextStyle(
                                                  fontFamily: 'NiraBold',
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              content: Text(
                                                "Your email address is not registered.",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'NiraRegular',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'NiraBold',
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      } catch (error) {
                                        print('Error during login: $error');
                                        Navigator.pop(
                                            context); // Dismiss the circular progress indicator
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(
                                              "An error occurred during login: $error",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              'Please enter both email and password.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Login ',
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
                                  "Don't have account?",
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
                                        builder: (context) => Register(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Color(0xFFFFC839),
                                        fontFamily: 'NiraBold',
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            if (loginAuthProvider.isLoading)
                              Center(child: CircularProgressIndicator()),
                            if (loginAuthProvider.errorMessage != null)
                              Text(
                                loginAuthProvider.errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      )
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
