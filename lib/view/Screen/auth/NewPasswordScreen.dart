import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPasswordScreen extends StatefulWidget {
  final OTP;
  final email;
  const NewPasswordScreen({super.key, this.OTP, this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  @override
  Widget build(BuildContext context) {
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
              child: Image.asset('lib/assets/Mobilelogin.gif',
                  width: 230, height: 180),
            ),
          ),
        ],),
      ),
    );
  }
}
