import 'package:flutter/material.dart';
import 'package:memo_note_app/Provider/Authprovider.dart';
import 'package:memo_note_app/Provider/NoteProvider.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:memo_note_app/view/Screen/auth/registerscreen.dart';
import 'package:memo_note_app/view/Screen/Homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Share_preferences().hasTokenInPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final bool isLoggedIn = snapshot.data!;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: isLoggedIn ? HomePageScreen(user: User(email: "")) : Register(),
          );
        }
      },
    );
  }
}
