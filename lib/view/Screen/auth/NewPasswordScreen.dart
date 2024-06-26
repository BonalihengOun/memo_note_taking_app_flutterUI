import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_note_app/view/Screen/auth/ForgotPassword_Screen.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Authprovider.dart';
import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final email;
  const NewPasswordScreen({super.key, this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgetPassword = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF610AA5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassScreen(),));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,size: 30,
                  ),
                ),
                SizedBox(width: 110),
                Container(
                  child: Center(
                    child: Image.asset(
                      'lib/assets/Memo..png',
                      width: 80,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: Image.asset('lib/assets/Mobile login-bro.png',
                    width: 240, height: 200),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enter',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NiraBold',
                        fontSize: 26),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'New Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NiraBold',
                        fontSize: 26),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your new password must be different from previous ',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NiraRegular',
                        fontSize: 13),
                  ),
                  SizedBox(width: 14),
                  Text(
                    'used password. The password must be at least 8 characters long and contain a number and a special character.',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NiraRegular',
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorStyle: TextStyle(
                              fontFamily: 'NiraRegular',
                              color: Color(0xFFFFC839),
                            ),
                            errorMaxLines: 3,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(15),
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
                                  _passwordObscureText = !_passwordObscureText;
                                });
                              },
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 18),
                            suffixIconConstraints: BoxConstraints(minWidth: 40),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                borderRadius: BorderRadius.circular(15)),
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle: const TextStyle(
                              fontFamily: 'NiraRegular',
                              color: Color(
                                0xFFFFC839,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontFamily: 'NiraRegular'),
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
                            prefixIconConstraints: BoxConstraints(minWidth: 18),
                            suffixIconConstraints: BoxConstraints(minWidth: 40),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ||
                                  value != _passwordController.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                      ), // Changed function cal
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Set border radius here
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.87,
                      MediaQuery.of(context).size.height * 0.064,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If form validation succeeds, create a User object
                      final password = _passwordController.text;
                      final confirmPassword = _confirmPasswordController.text;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            semanticsLabel: 'Loading',
                            semanticsValue: '20%',
                          ),
                        ),
                      );

                      try {
                        final ChangePassword =
                            await forgetPassword.verifyOtpAndResetPassword(
                                widget.email,
                                password,
                                confirmPassword,
                                context);
                        if (ChangePassword) {
                          await Future.delayed(
                              const Duration(seconds: 2));
                          Navigator.pop(context);
                          showCustomAlertDialog(
                            context,
                            'Success',
                            'Your password has been reset successfully.',
                            'Please login with your new password.',
                            Colors.green,
                            imagePath: 'lib/assets/check.png',
                          );
                          await Future.delayed(
                              const Duration(seconds: 2));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen()));

                          return;
                        } else if (!ChangePassword) {
                          await Future.delayed(
                              const Duration(seconds: 2));
                          Navigator.pop(context);
                          showCustomAlertDialog(
                            context,
                            'Error',
                            'There are something wrong please try again.',
                            'Please try again.',
                            Colors.red,
                            imagePath: 'lib/assets/error.png',
                          );
                          await Future.delayed(
                              const Duration(seconds: 2));
                          Navigator.pop(context);
                          return;
                        }
                      } catch (error) {
                        print(error);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error!"),
                            content: Text(
                                "An error occurred during update password. Please try again."),
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
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'NiraBold',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
