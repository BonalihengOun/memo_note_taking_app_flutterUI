import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:memo_note_app/Provider/Authprovider.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/view/Screen/auth/login_screen.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPVerificationScreen extends StatefulWidget {
  final User user;
  const OTPVerificationScreen({super.key, required this.user});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
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
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     authProvider.addListener(() {
  //       if (authProvider.registrationSuccessful) {
  //         setState(() {
  //           _isCountdownStarted = true;
  //         });
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    _otpController.dispose();
    _timerCountdown.endTime;
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
                          '${widget.user.email}',
                          style: TextStyle(
                              color: Color(0xFFFFC839),
                            fontFamily: 'NiraSemi',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' to verify Your Account!',
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
                        try {
                          final isOTPCorrect = await authProvider.verifyOTP(
                              _otpController.text, context);
                          if (isOTPCorrect) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => Center(
                                child: CircularProgressIndicator(),

                              ),
                            );
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          } else {
                            // Show error dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Warning!"),
                                content: const Text(
                                    "Invalid OTP or OTP is Expired. Please try again."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (error) {
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
                    SizedBox(height: 12,),
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
                        TextButton(
                          onPressed: () async {
                            if (widget.user.email != null) {
                              setState(() {
                                _isResendingOTP = true;
                              });
                              try {
                                await authProvider.resendOTP(
                                    widget.user.email!, context);
                                // Show success dialog
                                if (_isCountdownStarted) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      backgroundColor: Colors.green[300],
                                      title: Text("Success"),
                                      content: Text('OTP has been resent successfully!!'),
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
                                  // Restart countdown
                                  _isCountdownStarted = false;
                                  _startCountdown();
                                }
                              } catch (error) {
                                print(error);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to resend OTP. Please try again.'),
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
                              ? CircularProgressIndicator(color: Colors.white,strokeAlign: CircularProgressIndicator.strokeAlignCenter,)
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
