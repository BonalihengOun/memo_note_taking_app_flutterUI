import 'package:flutter/material.dart';
import 'package:memo_note_app/Provider/Authprovider.dart';
import 'package:memo_note_app/Provider/Noteprovider.dart';
import 'package:memo_note_app/Provider/Tagprovider.dart';

import 'package:memo_note_app/model/notePaper.dart';
import 'package:memo_note_app/model/notepaperRequest.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:memo_note_app/view/Screen/Note_detail_screen.dart';
import 'package:memo_note_app/view/Screen/auth/registerscreen.dart';
import 'package:memo_note_app/view/Screen/Homepage.dart';
import 'package:provider/provider.dart';

import 'model/userResponse.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
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

            title: 'Memo Note App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home:
            // NoteDetailScreen(
            //   note: Notepaper(
            //     title: 'Initial Title',
            //     note_content: 'Initial Content',
            //     note_description: 'Initial Description',
            //     notedId: 0, creationDate: DateTime.now(),
            //     users: UserResponse(userId: 0, username: '', email: ''),
            //     tagsLists: [],
            //     selectColor: Colors.white,
            //
            //     // Add other properties as needed
            //   ),
            // ),
            isLoggedIn
                ? FutureBuilder<String?>(
              future: Share_preferences().getTokenFromPrefs(),
              builder: (context, tokenSnapshot) {
                if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (tokenSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${tokenSnapshot.error}'),
                    ),
                  );
                } else {
                  final token = tokenSnapshot.data;
                  if (token != null) {
                    // Fetch user data using token
                    return const HomePageScreen(loginResponse: null,);
                  } else {
                    return Register();
                  }
                }
              },
            )
                : Register(),
          );
        }
      },
    );
  }
}
