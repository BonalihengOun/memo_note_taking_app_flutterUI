import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:memo_note_app/Provider/Authprovider.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/view/Screen/auth/ForgotPassword_Screen.dart';
import 'package:memo_note_app/view/Screen/auth/NewPasswordScreen.dart';
import 'package:memo_note_app/view/Screen/auth/login_screen.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPVerifiForgetPasswordScreen extends StatefulWidget {
  final email;
  const OTPVerifiForgetPasswordScreen({super.key, required this.email});

  @override
  State<OTPVerifiForgetPasswordScreen> createState() => _OTPVerifiForgetPasswordScreen();
}

class _OTPVerifiForgetPasswordScreen extends State<OTPVerifiForgetPasswordScreen> {
  final _otpController = TextEditingController();
  bool _isCountdownStarted = false;
  bool _isResendingOTP = false;
  late TimerCountdown _timerCountdown;
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    if (!_isCountdownStarted) {
      _timerCountdown = TimerCountdown(
        format: CountDownTimerFormat.minutesSeconds,
        endTime: DateTime.now().add(Duration(minutes: 2)),
        onEnd: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Warning!"),
              content: Text('OTP verification time expired. Please resend OTP'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isCountdownStarted = false;
                    _startCountdown();
                  },
                  child: Text("Resend OTP"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isCountdownStarted = false;
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          );
        },
      );
      _isCountdownStarted = true;
    }
  }

  void _restartCountdown() {
    setState(() {
      _isCountdownStarted = false;
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _timerCountdown.endTime;
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF610AA5),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(children: [
            Container(
              child: Center(
                child: Image.asset('lib/assets/otp.png',
                    width: 90, height: 124, alignment: Alignment(5, 8)),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.19),
                child: Column(
                  children: [
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NiraBold',
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'We have sent an OTP to your Email:',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NiraSemi',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${widget.email}',
                          style: TextStyle(
                            color: Color(0xFFFFC839),
                            fontFamily: 'NiraSemi',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' to make this email is your account!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NiraSemi',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Pinput(
                        validator: (value) => value!.isEmpty ||
                            value != _otpController.text
                            ? 'Please Input OTP Code'
                            : null,
                        animationCurve: Curves.bounceIn,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        length: 6,
                        defaultPinTheme: PinTheme(
                          textStyle: const TextStyle(
                              fontFamily: 'NiraBold', fontSize: 16),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(335, 50),
                      ),
                      onPressed: () async {
                        // Check if OTP code is not empty and matches the expected value
                        if (_otpController.text.isNotEmpty) {
                          try {
                            final isOTPCorrect = await authProvider.verifyOTPForgotPassword(
                                _otpController.text, context);
                            if (isOTPCorrect) {
                              // Show loading indicator while verifying OTP
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    strokeCap: StrokeCap.round,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    semanticsLabel: 'Loading',
                                    semanticsValue: '20%',
                                  ),
                                ),
                              );
                              // Simulate verification process with a delay
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context); // Close loading indicator dialog
                              // Show success dialog after successful verification
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
                                                    Text('Successfull',style: TextStyle(fontFamily: 'NiraBold',fontSize: 20,color: Colors.green),),
                                                    SizedBox(height: 10),
                                                    Center(child: Text('Please enter new password',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 14,color: Colors.black54),)),
                                                    SizedBox(height: 5),
                                                    Text('Please login to continue',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 12,color: Colors.black54),),
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
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK',style: TextStyle(fontFamily: 'NiraBold',fontSize: 16),),
                                        )
                                      ],
                                    ),
                              );
                              await Future.delayed(const Duration(seconds: 1));
                              Navigator.pop(context);
                              // Navigate to login screen after successful verification
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewPasswordScreen(
                                      OTP: _otpController.text,
                                      email: widget.email,
                                    )),
                              );
                            } else {
                              // Show error dialog for invalid OTP or expired OTP
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    strokeCap: StrokeCap.round,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    semanticsLabel: 'Loading',
                                    semanticsValue: '20%',
                                  ),
                                ),
                              );
                              // Simulate verification process with a delay
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context);
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
                                                      child: Image.asset('lib/assets/warning.png',width: 60,height: 60,),
                                                    ),
                                                    Text('Warning',style: TextStyle(fontFamily: 'NiraBold',fontSize: 20,color: Colors.amber),),
                                                    SizedBox(height: 10),
                                                    Center(child: Text('Invalid OTP or Expired OTP!!!',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 14,color: Colors.black54),)),
                                                    SizedBox(height: 5,),
                                                    Text('Please try again',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 12,color: Colors.black54),),
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
                              await Future.delayed(const Duration(seconds: 1));
                              Navigator.pop(context);
                            }
                          } catch (error) {
                            // Handle error during OTP verification
                            if (kDebugMode) {
                              print(error);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'An error occurred during OTP verification.'),
                              ),
                            );
                          }
                        }
                      },

                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          color: Color(0xFF610AA5),
                          fontFamily: 'NiraBold',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OTP will Expired in: ',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NiraSemi',
                              fontSize: 14),
                        ),
                        if (_isCountdownStarted)
                          TimerCountdown(
                            spacerWidth: 1,
                            enableDescriptions: false,
                            format: CountDownTimerFormat.minutesSeconds,
                            endTime: DateTime.now().add(Duration(minutes: 2)),
                            timeTextStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NiraSemi',
                              fontSize: 14,
                            ),
                            onEnd: () {
                              setState(() {
                                _isCountdownStarted = false;
                              });
                            },
                          ),
                        TextButton(
                          onPressed: () async {
                            if (widget.email != null) {
                              setState(() {
                                _isResendingOTP = true;
                              });
                              try {
                                await authProvider.requestOTP(
                                    widget.email!, context);
                                if (!_isCountdownStarted) {
                                  _restartCountdown(); // Restart the countdown timer if it has ended
                                }
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
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Image.asset('lib/assets/check.png',width: 60,height: 60,),
                                                      ),
                                                      Text('Successfull',style: TextStyle(fontFamily: 'NiraBold',fontSize: 20,color: Colors.green),),
                                                      SizedBox(height: 10),
                                                      Center(child: Text('Resent OTP successfully',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 14,color: Colors.black45),)),
                                                      SizedBox(height: 5,),
                                                      Text('Please check your email',style: TextStyle(fontFamily: 'NiraRegular',fontSize: 12,color: Colors.black45),),
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
                                await Future.delayed(const Duration(seconds: 1));
                                Navigator.pop(context);
                              } catch (error) {
                                print(error);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to resend OTP. Please try again.',
                                    ),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isResendingOTP = false;
                                });
                              }
                            }
                          },
                          child: _isResendingOTP
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeAlign: CircularProgressIndicator
                                      .strokeAlignCenter,
                                )
                              : Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: Color(0xFFFFC839),
                                    fontFamily: 'NiraBold',
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    if (authProvider.isLoading)
                      Center(child: CircularProgressIndicator()),
                    if (authProvider.errorMessage != null)
                      Text(
                        authProvider.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      )),
    );
  }
}
