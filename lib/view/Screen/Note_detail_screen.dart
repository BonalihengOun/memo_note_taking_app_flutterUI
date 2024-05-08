

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:memo_note_app/model/TagRequest.dart';
import 'package:memo_note_app/model/notePaper.dart';
import 'package:memo_note_app/model/notepaperRequest.dart';
import 'package:memo_note_app/model/Tag.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:memo_note_app/view/Screen/Homepage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../../Provider/Noteprovider.dart';
import '../../Provider/Tagprovider.dart';
import 'auth/login_screen.dart';

class NoteDetailScreen extends StatefulWidget {
  final Notepaper? note;
  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  late Future<List<Tag>> _tagListFuture = Future.value([]);
  final _prefs = Share_preferences();
  String? _selectedTagName;
  List<int> selectedTagsId = [];
  List<Tag> selectedTags = [];
  Color _pickerColor = Colors.white;
  bool isFinished = false;
  List<Color> _pickedColors = [];
  List<Tag> _tags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTag();
    if (widget.note != null) {
      _populateFields();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _noteDescriptionController.dispose();
    super.dispose();
  }

  void _populateFields() {
    _titleController.text = widget.note!.title ?? '';
    _contentController.text = widget.note!.note_content ?? '';
    _noteDescriptionController.text = widget.note!.note_description ?? '';
    for (var tagIdObj in widget.note!.tagsLists ?? []) {
      if (tagIdObj is int) {
        int tagId = tagIdObj;
        Tag? tag = _tags.firstWhere(
              (tag) => tag.tagId == tagId,
          orElse: () =>
              Tag(tagId: 0, tagName: ''), // Provide a default Tag object here
        );
        if (tag != null) {
          selectedTags.add(tag);
        }
      }
    }
    if (widget.note!.selectColor != null) {
      _pickedColors.add(widget.note!.selectColor!);
    }
    if(widget.note!.creationDate != null){
       formatCreationDate(widget.note!.creationDate);
    }
  }

  void _fetchTag() async {
    final token = await _prefs.getTokenFromPrefs();
    if (token != null) {
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      setState(() {
        _tagListFuture = tagProvider.getAllTags();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F5EC),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff610AA5),
                      ),
                      child: IconButton(
                        icon: const Image(
                          image: AssetImage("lib/assets/left_back.png"),
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePageScreen()));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff610AA5),
                      ),
                      child: IconButton(
                        icon: const Image(
                          image: AssetImage("lib/assets/dots.png"),
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 420,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        color: Color(0xffF6F5EC),
                        height: 60,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'NiraBold',
                            fontSize: 20,
                          ),
                          controller: _titleController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10,),
                            border: InputBorder.none,
                            hintText: 'Title your note . . .',
                            hintStyle: TextStyle(
                              fontFamily: 'NiraSemi',
                              fontSize: 25,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          maxLines: 2,
                          keyboardType:
                              TextInputType.multiline, // Allow unlimited lines
                        ),
                      ),
                      Container(
                        height: 300,
                        color: Color(0xffF6F5EC),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a content';
                            }
                            return null;
                          },
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'NiraRegular',
                            fontSize: 16,
                          ),
                          controller: _contentController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            border: InputBorder.none,
                            hintText: 'Write Something note . . .',
                            hintStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'NiraRegular',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          maxLines: null,
                          keyboardType:
                              TextInputType.multiline, // Allow unlimited lines
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(0xffF6F5EC),
                          title: Text(
                            'Add Tag',
                            style: TextStyle(fontFamily: 'NiraSemi'),
                          ),
                          content: TextField(
                            controller: _tagController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Enter Tag Name',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontFamily: 'NiraBold'),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                TagRequest addTag =
                                    TagRequest(tagName: _tagController.text);
                                final tagProvider = Provider.of<TagProvider>(
                                    context,
                                    listen: false);

                                try {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  // Navigator.pop(context); // Close the circular progress indicator
                                  final bool isSuccess =
                                      await tagProvider.createTag(addTag);
                                  if (isSuccess) {
                                    _fetchTag(); // Close the success dialog
                                  } else {
                                    showCustomAlertDialog(
                                      context,
                                      'Error',
                                      'Tag Already Exists',
                                      'Tag cannot with same name.',
                                      Colors.red.shade700,
                                      imagePath: 'lib/assets/cross.png',
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                  }
                                } catch (error) {
                                  print('Error creating tag: $error');
                                  Navigator.pop(
                                      context); // Close the circular progress indicator
                                  showCustomAlertDialog(
                                    context,
                                    'Error',
                                    'Failed to Create Tag',
                                    'An error occurred while creating the tag.',
                                    Colors.red.shade700,
                                    imagePath: 'lib/assets/error.png',
                                  );
                                }
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(fontFamily: 'NiraBold'),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF610AA5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder<List<Tag>>(
                    future: _tagListFuture,
                    builder: (context, snapshot) {
                      if (_tagListFuture == null) {
                        return CircularProgressIndicator(); // or any other loading indicator
                      }
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
                        _tags = snapshot.data ?? [];
                        if (_tags.isEmpty) {
                          return Container();
                        }
                        return Container(
                          margin: EdgeInsets.only(left: 15),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.055,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _tags.length,
                            itemBuilder: (context, index) {
                              final tag = _tags[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedTagsId.contains(tag.tagId)) {
                                        selectedTagsId.remove(tag
                                            .tagId); // Deselect if already selected
                                      } else {
                                        selectedTagsId.add(
                                            tag.tagId); // Add to selected tags
                                      }
                                      print(selectedTagsId);
                                    });
                                  },
                                  child: Chip(
                                    onDeleted: () async {
                                      final tagProvider =
                                          Provider.of<TagProvider>(context,
                                              listen: false);
                                      bool deleted = await tagProvider
                                          .deleteTag(tag.tagId.toString());
                                      if (deleted) {
                                        _fetchTag();
                                      } else {}
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    deleteIconColor:
                                        selectedTagsId.contains(tag.tagId)
                                            ? Colors.white
                                            : Colors.black,
                                    label: Text(
                                      tag.tagName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    backgroundColor:
                                        selectedTagsId.contains(tag.tagId)
                                            ? Color(0xff610AA5)
                                            : Colors.grey.shade200,
                                    labelStyle: TextStyle(
                                      fontFamily: 'NiraSemi',
                                      color: selectedTagsId.contains(tag.tagId)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.68,
                ),
                child: Text('Select Color',
                    style: TextStyle(
                      fontFamily: 'NiraSemi',
                    ))),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showColorPickerDialog(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _pickerColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset('lib/assets/colorpicker.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Wrap(
                    spacing: 10,
                    children: _pickedColors
                        .map(
                          (color) => GestureDetector(
                            onTap: () {
                              _toggleColorSelection(color);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: _pickedColors.contains(color)
                                    ? Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: _pickedColors.contains(color)
                                  ? Center(
                                      child:
                                          Icon(Icons.done, color: Colors.white),
                                    )
                                  : null,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.48,
              ),
              child: const Text(
                'Additional Description',
                style: TextStyle(
                  fontFamily: 'NiraSemi',
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Container(
                  height: 310,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    color: Color(0xffF6F5EC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(
                          fontFamily: 'NiraRegular',
                          fontSize: 16,
                        ),
                        controller: _noteDescriptionController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          border: InputBorder.none,
                          hintText: 'Write Description . . .',
                          hintStyle: TextStyle(
                            fontFamily: 'NiraRegular',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        maxLines: null, // Allow unlimited lines
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: const Text(
                          'Created Date',
                          style: TextStyle(
                            fontFamily: 'NiraSemi',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'lib/assets/gallery.png',
                          width: 34,
                          height: 34,
                        ),
                      )
                    ],
                  ),
                ),
                //Show Creation Data

                Padding(
                  padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width*0.6,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatCreationDate(widget.note!.creationDate),maxLines:1,overflow: TextOverflow.fade,
                        style: TextStyle(fontFamily: 'NiraSemi', fontSize: 16,letterSpacing:1),
                      ),
                      SizedBox(height: 5),
                      Text(
                        formatCreationDateTime(widget.note!.creationDate),maxLines:1,overflow: TextOverflow.fade,
                        style: TextStyle(fontFamily: 'NiraSemi', fontSize: 14,letterSpacing:1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            //Show Add files photos & Video

            //Button Submit note
            if (widget.note != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.88,
                      MediaQuery.of(context).size.height * 0.054,
                    ),
                    backgroundColor: Color(0xff610AA5),
                  ),
                  onPressed: () async {
                    _saveOrUpdateNote();
                  },
                  child: const Text(
                    'Save Note',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NiraSemi',
                        color: Colors.white),
                  ),
                ),
              )
            else if (widget.note == null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SwipeableButtonView(
                  buttonText: 'Set as Done',
                  buttontextstyle: TextStyle(
                      fontFamily: 'NiraBold',
                      fontSize: 16,
                      color: Colors.white),
                  buttonWidget: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 30,
                      weight: 200,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Color(0xFF610AA5),
                  isFinished: isFinished,
                  onWaitingProcess: () {
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        isFinished = true;
                      });
                    });
                  },
                  onFinish: () async {
                    _saveOrUpdateNote();
                  },
                ),
              ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveOrUpdateNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.note == null) {
      await _createNewNote();
    } else {
      await _updateExistingNote();
    }
  }

  Future<void> _createNewNote() async {
    final newNote = _buildNoteRequestObject();
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    try {
      await noteProvider.createNote(newNote);
      _showSnackbar('Note created successfully', Colors.green);
      _navigateToHomePage();
    } catch (error) {
      _showSnackbar('Error creating note: $error', Colors.red);
    }
  }

  Future<void> _updateExistingNote() async {
    final updatedNote = _buildNoteRequestObject();
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final noteId = widget.note!.notedId.toString();
    try {
      await noteProvider.updateNotebyId(updatedNote, noteId);
      _showSnackbar('Note updated successfully', Colors.green);
      _navigateToHomePage();
    } catch (error) {
      _showSnackbar('Failed to update note: $error', Colors.red);
    }
  }

  NotepaperRequest _buildNoteRequestObject() {
    return NotepaperRequest(
      notedId: widget.note?.notedId ?? 0,
      title: _titleController.text,
      note_content: _contentController.text,
      note_description: _noteDescriptionController.text,
      selectColor: _pickedColors.isNotEmpty
          ? Color(int.parse(
                  _pickedColors[0].value.toRadixString(16).padLeft(8, '0'),
                  radix: 16) +
              0xFF000000)
          : null,
      tagsLists: selectedTagsId.cast<int>(),
      receiveFiles: [],
      creationDate: widget.note?.creationDate ?? DateTime.now(),
    );
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _navigateToHomePage() {
    // Navigate to homepage after updating the note
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: HomePageScreen(),
        ),
      );
    });
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: (Color color) {
                // Print the selected color
                print(
                    color); // This will print the selected color to the console

                // Add the selected color to the list of picked colors
                setState(() {
                  _pickedColors.clear();
                  _pickedColors.add(ColorSwatch(color.value, <int, Color>{}));
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addColor(_pickerColor);
                Navigator.of(context).pop();
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  void _addColor(Color color) {
    setState(() {
      _pickedColors.add(color);
    });
  }

  void _toggleColorSelection(Color color) {
    setState(() {
      if (_pickedColors.contains(color)) {
        _pickedColors.remove(color);
      } else {
        _pickedColors.add(color);
      }
    });
  }

  String formatCreationDate(DateTime creationDate) {
    final formatter = DateFormat('yyyy-MMM-dd');
    return formatter.format(creationDate);
  }
  String formatCreationDateTime(DateTime creationDate) {
    final formatter = DateFormat('hh:mm:ss a');
    return formatter.format(creationDate);
  }
}
