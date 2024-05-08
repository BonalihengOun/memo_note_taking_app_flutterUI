import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo_note_app/model/notePaper.dart';
import 'package:provider/provider.dart';

import '../../Provider/Noteprovider.dart';
import '../Screen/Note_detail_screen.dart';

class SearchComponentNoteByTitle extends StatefulWidget {
  const SearchComponentNoteByTitle({Key? key}) : super(key: key);

  @override
  State<SearchComponentNoteByTitle> createState() =>
      _SearchComponentNoteByTitleState();
}

class _SearchComponentNoteByTitleState
    extends State<SearchComponentNoteByTitle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(context: context, delegate: NoteSearchByTitle());
      },
      child: Icon(Icons.search), // Add an icon to indicate search functionality
    );
  }
}

class NoteSearchByTitle extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Image.asset('lib/assets/wrong.png', width: 24, height: 24),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Image.asset('lib/assets/arrowback.png', width: 24, height: 24),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Notepaper>>(
      future: Provider.of<NoteProvider>(context, listen: false)
          .filterNotedBytitle(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Notepaper> searchList = snapshot.data ?? [];
          if (searchList.isEmpty) {
            return Center(child: Image.asset('lib/assets/404.gif'));
          }
          return ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (context, index) {
              final suggestion = searchList[index];
              final backgroundColor =
                  suggestion.selectColor ?? Colors.transparent;
              String formatCreationDate(DateTime creationDate) {
                final formatter = DateFormat('yyyy-MMM-dd hh:mm:ss a');
                return formatter.format(creationDate);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(
                        note: suggestion,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid,
                        width: 4,
                        color: Colors.black.withOpacity(1.0)),
                    borderRadius: BorderRadius.circular(20),
                    color: backgroundColor,
                    image: backgroundColor == Colors.transparent
                        ? DecorationImage(
                            image: AssetImage(Notepaper.defaultImagePath),
                            fit: BoxFit.fill,
                          )
                        : null, // Use background image only if color is not provided
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: ${suggestion.title}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18, fontFamily: 'NiraBold'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Content: ${suggestion.note_content}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, fontFamily: 'NiraSemi'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Description: ${suggestion.note_description}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NiraRegular'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Creation Date: ${formatCreationDate(suggestion.creationDate)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'NiraRegular',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
