import 'package:flutter/material.dart';
import 'package:memo_note_app/Provider/NoteProvider.dart';
import 'package:memo_note_app/model/User.dart';
import 'package:memo_note_app/model/notePaper.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:provider/provider.dart';
import 'auth/login_screen.dart';

class HomePageScreen extends StatefulWidget {
  final User user;
  const HomePageScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Share_preferences _prefs = Share_preferences();
  late Future<List<Notepaper>> _notePaperListFuture;
  bool _isLoading = true; // Initially set to true to show a loading indicator

  @override
  void initState() {
    super.initState();
    _fetchTokenAndData();
  }

  Future<void> _fetchTokenAndData() async {
    final token = await _prefs.getTokenFromPrefs();
    if (token != null) {
      setState(() {
        _notePaperListFuture =
            Provider.of<NoteProvider>(context, listen: false).getAllNote();
      });
    }
    setState(() {
      _isLoading = false; // Set loading indicator to false after fetching data
    });
  }

  Future<void> _logout(BuildContext context) async {
    await _prefs.removeTokenFromPrefs();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<List<Notepaper>>(
              future: _notePaperListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final notePapers = snapshot.data!;
                  if (notePapers.isEmpty) {
                    return Center(
                      child: Text('Welcome to MEMO'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: notePapers.length,
                      itemBuilder: (context, index) {
                        final notePaperItem = notePapers[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NotePaper ID: ${notePaperItem.noteId}'),
                            Text('Title: ${notePaperItem.title}'),
                            Text('Content: ${notePaperItem.note_content}'),
                            Text(
                                'Description: ${notePaperItem.note_description}'),
                            Text(
                                'Creation Date: ${notePaperItem.creationDate}'),
                            Text('Select Color: ${notePaperItem.selectColor}'),
                            Divider(),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
    );
  }
}
