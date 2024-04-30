import 'package:flutter/material.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:provider/provider.dart';

import '../../Provider/Authprovider.dart';
import 'auth/login_screen.dart';

class HomePageScreen extends StatefulWidget {
  final User user;
  const HomePageScreen({super.key, required this.user});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Share_preferences _prefs =
      Share_preferences(); // Initialize SharedPreferences

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    final token = await _prefs.getTokenFromPrefs();
    setState(() {
      _accessToken = token;
    });
  }

  Future<void> _logout() async {
    await _prefs.removeTokenFromPrefs();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Homepage = Provider.of<AuthProvider>(context);
    print('User email: ${widget.user.email}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: Center(
        child: _accessToken != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('this Token is for ${widget.user.email}'),
                  Text('Access Token: $_accessToken'),
                  ElevatedButton(
                    onPressed: () {
                      // Example of making an authenticated API request
                      Homepage.fetchData();
                    },
                    child: Text('Fetch Data'),
                  ),
                ],
              )
            : Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Loading...'),
                ],
              ),
      ),
    );
  }
}
