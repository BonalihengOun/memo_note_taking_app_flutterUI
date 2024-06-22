import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_validator/email_validator.dart';
import 'package:memo_note_app/view/Screen/auth/OTPVerifiForgetPasswordScreen.dart';
import 'package:memo_note_app/view/Screen/auth/login_screen.dart';
import 'package:provider/provider.dart';
import '../../../Provider/Authprovider.dart';
import '../../../model/User.dart';
import 'OTPVerificationScreen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forgetPassword = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF610AA5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: Image.asset('lib/assets/Memo..png',
                    width: 80, height: 50, alignment: Alignment(5, 3)),
              ),
            ),
            SizedBox(height: 70),
            Container(
              child: Center(
                child: Image.asset('lib/assets/Forgot password.gif',
                    width: 230, height: 180),
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NiraBold',
                      fontSize: 30),
                ),
                SizedBox(width: 10),
                Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NiraBold',
                      fontSize: 30),
                ),
                Text(
                  '?',
                  style: TextStyle(
                      color: Colors.amber,
                      fontFamily: 'NiraBold',
                      fontSize: 30),
                ),
              ],
            ),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Please enter your email address ',
                    style: TextStyle(
                        fontFamily: 'NiraRegular', color: Colors.white),
                  ),
                  Text(
                    'to receive a new OTP ',
                    style: TextStyle(
                        fontFamily: 'NiraRegular', color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            // Email
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
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
                                        color: Color(0xFFFFC839),
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  errorStyle: TextStyle(
                                    fontFamily: 'NiraRegular',
                                    color: Color(0xFFFFC839),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                            SizedBox(height: 40),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.82,
                                    MediaQuery.of(context).size.height * 0.064,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final email = _emailController.text;
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) => Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          strokeCap: StrokeCap.round,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          semanticsLabel: 'Loading',
                                          semanticsValue: '20%',
                                        ),
                                      ),
                                    );

                                    try {
                                      final isEmailRegistered =
                                          await forgetPassword
                                              .isEmailregistered(email);

                                      if (!isEmailRegistered) {
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        Navigator.pop(context);
                                        showCustomAlertDialog(
                                          context,
                                          'Warning',
                                          'This Email is not registered!!!',
                                          'Please use a different email.',
                                          Colors.amber,
                                          imagePath: 'lib/assets/warning.png',
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        return; // Exit the function if email is not registered
                                      }

                                      final requestOTP = await forgetPassword
                                          .requestOTP(email, context);
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      Navigator.pop(context);

                                      if (requestOTP) {
                                        showCustomAlertDialog(
                                          context,
                                          'Success',
                                          'OTP sent successfully',
                                          'Please check your email for OTP.',
                                          Colors.green,
                                          imagePath: 'lib/assets/check.png',
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OTPVerifiForgetPasswordScreen(
                                              email: email,
                                            ),
                                          ),
                                        );
                                        _emailController
                                            .clear(); // Clear the email field
                                      } else {
                                        showCustomAlertDialog(
                                          context,
                                          'Error',
                                          'Failed to request OTP Code',
                                          'Please try again later.',
                                          Colors.red,
                                          imagePath: 'lib/assets/cross.png',
                                        );
                                      }
                                    } catch (error) {
                                      // Handle login error
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      Navigator.pop(
                                          context); // Dismiss loading dialog
                                      showCustomAlertDialog(
                                        context,
                                        'Error',
                                        'An error occurred during requestOTP',
                                        'Please try again later.',
                                        Colors.red,
                                        imagePath: 'lib/assets/cross.png',
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Request OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'NiraBold',
                                  ),
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Remember password?",
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
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Color(0xFFFFC839),
                                        fontFamily: 'NiraBold',
                                        fontSize: 14),
                                  ),
                                ),
                              ],
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
