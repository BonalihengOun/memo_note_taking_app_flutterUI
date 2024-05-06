import 'package:flutter/material.dart';
import 'package:memo_note_app/Provider/Noteprovider.dart';
import 'package:memo_note_app/Provider/Tagprovider.dart';

import 'package:memo_note_app/model/notePaper.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:provider/provider.dart';

import '../../model/tag.dart';
import 'Note_detail_screen.dart';
import 'auth/login_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Share_preferences _prefs = Share_preferences();
  late Future<List<Notepaper>> _notePaperListFuture;
  late Future<List<Tag>> _tagListFuture;
  List<Notepaper> _notePapers = [];
  String? _selectedTagName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _updateSelectedTagName('All');
  }

  void _fetchData() async {
    final token = await _prefs.getTokenFromPrefs();
    if (token != null) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      setState(() {
        _notePaperListFuture = noteProvider.getAllNote();
        _tagListFuture = tagProvider.getAllTags();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _updateSelectedTagName(String tagName) {
    setState(() {
      _selectedTagName = tagName == 'All' ? null : tagName;
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

  void _handlePinAction(Notepaper _notePapers) {
    setState(() {
      // Toggle the pin status of the note
      _notePapers.isPinned = !_notePapers.isPinned;
      // If the note is pinned, move it to the top of the list in the UI
      if (_notePapers.isPinned) {
        _notePaperListFuture = _notePaperListFuture.then((notePapers) {
          // Remove the note from its current position in the list
          notePapers.remove(_notePapers);
          // Insert the note at the beginning of the list
          notePapers.insert(0, _notePapers);
          return notePapers;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F5EC),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        icon: const Image(
                          image: AssetImage("lib/assets/user.png"),
                          width: 26,
                          height: 26,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        splashRadius: 25,
                        alignment: Alignment.centerRight,
                        icon: const Image(
                          image: AssetImage("lib/assets/search.png"),
                          width: 26,
                          height: 26,
                        ),
                        onPressed: () {
                          _logout(context);
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: _isLoading
                            ? Container()
                            : // If loading, show an empty container
                            (_tagListFuture != null ||
                                    _notePaperListFuture == null)
                                ? Container(
                                    child: Image(
                                      image: AssetImage(
                                          'lib/assets/Welcome_Sir.png'),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                    ),
                                  )
                                : Container() // If data not available, show an empty container

                        ),
                    Container(
                        child: _isLoading
                            ? Container()
                            : // If loading, show an empty container
                            (_tagListFuture == null &&
                                    _notePaperListFuture != null)
                                ? Container(
                                    child: Image(
                                      image: AssetImage(
                                          'lib/assets/Welcome_Sir.png'),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                    ),
                                  )
                                : Container() // If data not available, show an empty container

                        ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: FutureBuilder<List<Tag>>(
                            future: _tagListFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                final List<Tag> tags = snapshot.data!;
                                if (tags.isEmpty) {
                                  return Container();
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.055,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: tags.length +
                                          1, // +1 for the "All" option
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return _buildTagFilterButton(
                                              "All", _selectedTagName == "All");
                                        } else {
                                          final tag = tags[index - 1];
                                          return _buildTagFilterButton(
                                              tag.tagName,
                                              tag.tagName == _selectedTagName);
                                        }
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder<List<Notepaper>>(
                    future: _notePaperListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff610AA5)),
                            semanticsLabel: 'Loading',
                            semanticsValue: '20%',
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final notePapers = snapshot.data!;
                        // Filter note papers based on selected tag name
                        final filteredNotePapers = _selectedTagName != null
                            ? notePapers
                                .where(
                                  (notePaper) => notePaper.tagsLists!.any(
                                      (tag) => tag.tagName == _selectedTagName),
                                )
                                .toList()
                            : notePapers;

                        if (filteredNotePapers.isEmpty) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 100),
                              child: Image(
                                image:
                                    AssetImage('lib/assets/Welcome_note.png'),
                                width: MediaQuery.of(context).size.width * 0.7,
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width * 90 / 100,
                              height:
                                  MediaQuery.of(context).size.height * 90 / 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: filteredNotePapers.length,
                                itemBuilder: (context, index) {
                                  final notePaper = filteredNotePapers[index];
                                  final backgroundColor =
                                      notePaper.selectColor ??
                                          Colors.transparent;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('notePaper: ${notePaper.title}');
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.5,
                                              color: Colors.black
                                                  .withOpacity(1.0)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: backgroundColor,
                                          image: backgroundColor ==
                                                  Colors.transparent
                                              ? DecorationImage(
                                                  image: AssetImage(Notepaper
                                                      .defaultImagePath),
                                                  fit: BoxFit.fill,
                                                )
                                              : null, // Use background image only if color is not provided
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      notePaper.title,
                                                      maxLines:
                                                          2, // Limit to 2 lines
                                                      overflow: TextOverflow
                                                          .ellipsis, // Show ellipsis if text overflows
                                                      style: TextStyle(
                                                        fontFamily: 'NiraBold',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  _buildCustomPopupMenu(
                                                      context, notePaper)
                                                ],
                                              ),
                                              Text(
                                                notePaper.note_content,
                                                style: TextStyle(
                                                  fontFamily: 'NiraRegular',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 10.0), // Set margin bottom to 10
        child: FloatingActionButton(
          backgroundColor: Color(0xff610AA5), // Set the background color
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteDetailScreen()),
            );
          },
          child: Icon(Icons.add, color: Colors.white), // Set the icon color
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildTagFilterButton(String tagName, bool isSelected) {
    final isAll = tagName == 'All';
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          _updateSelectedTagName(tagName);
        },
        child: Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            color: isSelected || (isAll && _selectedTagName == null)
                ? Color(0xff610AA5)
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                tagName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected || (isAll && _selectedTagName == null)
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'NiraBold',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomPopupMenu(BuildContext context, Notepaper notePaper) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'pin',
          child: Row(
            children: [
              Image.asset(
                'lib/assets/pin.png',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Pin',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NiraRegular',
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Image.asset(
                'lib/assets/trash-bin.png',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NiraRegular',
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'pin') {
          _handlePinAction(notePaper);
        } else if (value == 'delete') {}
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.more_vert),
      ),
    );
  }
}
