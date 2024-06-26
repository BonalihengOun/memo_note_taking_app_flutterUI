import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:memo_note_app/Provider/Authprovider.dart';
import 'package:memo_note_app/Provider/Noteprovider.dart';
import 'package:memo_note_app/Provider/Tagprovider.dart';
import 'package:memo_note_app/model/LoginResponse.dart';
import 'package:memo_note_app/model/User.dart';

import 'package:memo_note_app/model/notePaper.dart';
import 'package:memo_note_app/model/userResponse.dart';
import 'package:memo_note_app/utils/share_preferrences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../model/Tag.dart';
import '../Components/SearchBarComponent.dart';
import 'Note_detail_screen.dart';
import 'auth/login_screen.dart';

class HomePageScreen extends StatefulWidget {
  final LoginResponse? loginResponse;
  const HomePageScreen({
    Key? key,
    required this.loginResponse,
  }) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Share_preferences _prefs = Share_preferences();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Tag> _selectedTags = [];
  late Future<List<Notepaper>> _notePaperListFuture;
  late Future<List<Tag>> _tagListFuture;
  UserResponse? _userProfile;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
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
      final userProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        _notePaperListFuture = noteProvider.getAllNote();
        _tagListFuture = tagProvider.getAllTags();
        _fetchUserProfile(userProvider);
        _isLoading = false;
      });
    }
  }

  void _fetchUserProfile(AuthProvider userProvider) async {
    try {
      final userProfile = await userProvider.getUserDetails();
      setState(() {
        _userProfile = userProfile;
      });
    } catch (error) {
      print(error);
    }
  }

  void _updateSelectedTagName(String tagName) {
    setState(() {
      _selectedTagName = tagName == 'All' ? null : tagName;
    });
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NiraBold',
                  color: Color(0xff610AA5),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontFamily: 'NiraSemi',
                          fontSize: 16,
                          color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            semanticsLabel: 'Loading',
                            semanticsValue: '20%',
                          ),
                        ),
                      );
                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.of(context).pop();
                      _logout(context);
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'NiraSemi',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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


  String maskEmail(String email) {
    if (email.isEmpty) return 'Loading...';
    int atIndex = email.indexOf('@');
    if (atIndex <= 1)
      return email; // If the email is too short to mask, return it as is
    String domain = email.substring(atIndex);
    String maskedName = email[0] + '*******' + email[atIndex - 1];
    return maskedName + domain;
  }
  void _showChangeUsernameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change Username',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff610AA5),
              fontFamily: 'NiraBold',
            ),
          ),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: "Enter new username",
              hintStyle: TextStyle(
                fontFamily: 'NiraSemi',
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            style: TextStyle(
              fontFamily: 'NiraSemi',
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'NiraBold',
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'NiraBold',
                  fontSize: 14,
                  color: Color(0xff610AA5),
                ),
              ),
              onPressed: () async {
                String newUsername = _usernameController.text;
                if (newUsername.isNotEmpty) {
                  final isSuccessful = await Provider.of<AuthProvider>(context, listen: false).changeUsername(newUsername, context);
                  if (isSuccessful) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Username changed successfully.')),
                    );
                    _fetchData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to change username.')),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final ChangeName = Provider.of<AuthProvider>(context);
    return RefreshIndicator(
      color: Color(0xff610AA5),
      onRefresh: () async {
        _fetchData();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF6F5EC),
        drawer: Drawer(
          backgroundColor: Color(0xffF6F5EC),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                  child: Container(
                    child: Image.asset('lib/assets/Welcome_Sir.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('lib/assets/Username.png', width: 25, height: 25),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _userProfile?.name ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'NiraSemi',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _showChangeUsernameDialog,
                        icon: Image.asset(
                          'lib/assets/edit.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
                  child: Row(
                    children: [
                      Image.asset('lib/assets/gmail.png', width: 25, height: 25),
                      SizedBox(width: 10),
                      Text(
                        maskEmail(_userProfile?.email ?? ''),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NiraSemi',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('lib/assets/password.png', width: 25, height: 25),
                          SizedBox(width: 10),
                          Text(
                            "Reset Password",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'NiraSemi',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff610AA5),
                                      fontFamily: 'NiraBold',
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: TextFormField(
                                            controller: _password,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'NiraRegular',
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: Color(0xff610AA5), width: 1.5),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: Color(0xFFFFC839), width: 1.5),
                                              ),
                                              errorStyle: TextStyle(
                                                fontFamily: 'NiraRegular',
                                                color: Colors.red,
                                              ),
                                            ),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter a password';
                                              } else if (!RegExp(
                                                  r"^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[@#$%^&+=!])(?=\S+$).{8,}$")
                                                  .hasMatch(value)) {
                                                return 'Password must be at least 8 characters long and contain at least one number, one letter, and one special character.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: TextFormField(
                                            controller: _confirmPassword,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'Confirm Password',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'NiraRegular',
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: Color(0xff610AA5), width: 1.5),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: Color(0xFFFFC839), width: 1.5),
                                              ),
                                              errorStyle: TextStyle(
                                                fontFamily: 'NiraRegular',
                                                color: Colors.red,
                                              ),
                                            ),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) => value!.isEmpty || value != _password.text
                                                ? 'Passwords do not match'
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontFamily: 'NiraBold',
                                          fontSize: 14,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                          fontFamily: 'NiraBold',
                                          fontSize: 14,
                                          color: Color(0xff610AA5),
                                        ),
                                      ),
                                      onPressed: () async {
                                        String password = _password.text;
                                        String confirmPassword = _confirmPassword.text;
                                        if (password.isEmpty || confirmPassword.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Please fill in all fields.')),
                                          );
                                          return;
                                        }
                                        if (password != confirmPassword) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Passwords do not match.')),
                                          );
                                          return;
                                        }

                                        if (_userProfile != null) {

                                          final ChangePassword =  await Provider.of<AuthProvider>(context, listen: false)
                                              .resetPassword(_userProfile?.email, password, confirmPassword, context);
                                          await Future.delayed(const Duration(seconds: 1));
                                          if (ChangePassword) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 5,
                                                  strokeCap: StrokeCap.round,
                                                  valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                                  semanticsLabel: 'Loading',
                                                  semanticsValue: '20%',
                                                ),
                                              ),
                                            );
                                            await Future.delayed(
                                                const Duration(seconds: 0));
                                            Navigator.pop(
                                                context); // Dismiss loading dialog
                                            showCustomAlertDialog(
                                              context,
                                              'Success',
                                              'Reset Password Successful',
                                              '',
                                              Colors.green.shade700,
                                              imagePath: 'lib/assets/check.png',
                                            );
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                            Navigator.pop(
                                                context);
                                            Navigator.pop(
                                                context);
                                          }else{
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to reset password.')),
                                            );
                                          }

                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('User profile not found.')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Image.asset(
                            'lib/assets/reset-password.png',
                            width: 25,
                            height: 25,
                            scale: 0.8,

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/logout.png', width: 25, height: 25),
                      TextButton(
                        onPressed: () {
                          _showLogoutConfirmation(context);
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'NiraSemi',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff610AA5)),
                  semanticsLabel: 'Loading',
                  semanticsValue: '20%',
                ),
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
                            image: AssetImage("lib/assets/menu-bar .png"),
                            width: 26,
                            height: 26,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
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
                            showSearch(
                                context: context,
                                delegate: NoteSearchByTitle());
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                if (_tagListFuture == null ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return Center();
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
                                      margin: EdgeInsets.only(left: 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.055,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: tags.length +
                                            1, // +1 for the "All" option
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return _buildTagFilterButton("All",
                                                _selectedTagName == "All");
                                          } else {
                                            final tag = tags[index - 1];
                                            return _buildTagFilterButton(
                                                tag.tagName,
                                                tag.tagName ==
                                                    _selectedTagName);
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                        (tag) =>
                                            tag.tagName == _selectedTagName),
                                  )
                                  .toList()
                              : notePapers;

                          if (filteredNotePapers.isEmpty) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: Center(
                                child: Column(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          'lib/assets/Empty.png'),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    Text(
                                      "Empty Notes",
                                      style: TextStyle(
                                          fontFamily: 'NiraBold',
                                          fontSize: 24,
                                          color: Colors.amber),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    90 /
                                    100,
                                height: MediaQuery.of(context).size.height *
                                    90 /
                                    100,
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
                                    String formatCreationDate(
                                        DateTime creationDate) {
                                      final formatter =
                                          DateFormat('yyyy-MMM-dd hh:mm:ss a');
                                      return formatter.format(creationDate);
                                    }

                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NoteDetailScreen(
                                                note: notePaper,
                                              ),
                                            ),
                                          );

                                          print(notePapers[index]);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.09,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                width: 3,
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
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
                                                              fontFamily:
                                                                  'NiraBold',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        _buildCustomPopupMenu(
                                                            context, notePaper)
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          notePaper
                                                              .note_content,
                                                          maxLines: 8,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'NiraRegular',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, bottom: 5),
                                                child: Row(
                                                  // Align bottom left
                                                  children: [
                                                    Flexible(
                                                      // Flexible widget for wrapping long text
                                                      child: Text(
                                                        formatCreationDate(
                                                            notePaper
                                                                .creationDate),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NiraSemi',
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
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
              if (mounted)
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: const NoteDetailScreen(
                          note: null,
                        )));
            },
            child: Icon(Icons.add, color: Colors.white), // Set the icon color
            shape: CircleBorder(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
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
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: isSelected || (isAll && _selectedTagName == null)
                  ? Color(0xff610AA5)
                  : Colors.black,
            ),
            color: isSelected || (isAll && _selectedTagName == null)
                ? Color(0xff610AA5)
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Center(
            child: Text(
              tagName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1,
                color: isSelected || (isAll && _selectedTagName == null)
                    ? Colors.white
                    : Colors.black,
                fontFamily: 'NiraBold',
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
          // Handle pin action if needed
        } else if (value == 'delete') {
          _deleteNote(context, notePaper);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.more_vert),
      ),
    );
  }

  void _deleteNote(BuildContext context, Notepaper notePaper) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Store a reference to the confirmation dialog
        AlertDialog confirmationDialog = AlertDialog(
          backgroundColor: Color(0xffF6F5EC),
          title: Text(
            'Confirm Deletion',
            style: TextStyle(fontFamily: 'NiraSemi', color: Colors.black),
          ),
          content: Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Show a loading indicator
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

                // Perform deletion logic here
                final noteProvider =
                    Provider.of<NoteProvider>(context, listen: false);
                try {
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.pop(
                      context); // Close the circular progress indicator
                  final bool isSuccess = await noteProvider
                      .deleteNote(notePaper.notedId.toString());
                  if (isSuccess) {
                    // showCustomAlertDialog(
                    //   context,
                    //   'Success',
                    //   'Note Deleted Successful',
                    //   'This note has been deleted.',
                    //   Colors.green.shade700,
                    //   imagePath: 'lib/assets/check.png',
                    // );
                    // await Future.delayed(const Duration(seconds: 1));
                    // Navigator.pop(context);
                    _fetchData();
                  } else {
                    showCustomAlertDialog(
                      context,
                      'Error',
                      'Note Already Deleted',
                      'This note has already been deleted.',
                      Colors.red.shade700,
                      imagePath: 'lib/assets/cross.png',
                    );
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pop(context);
                  }
                } catch (error) {
                  print('Error Deleting note: $error');
                  Navigator.pop(
                      context); // Close the circular progress indicator
                  showCustomAlertDialog(
                    context,
                    'Error',
                    'Failed to delete Note',
                    'An error occurred while deleting the note.',
                    Colors.red.shade700,
                    imagePath: 'lib/assets/cross.png',
                  );
                }
                Navigator.pop(
                    context); // Pop off the confirmation dialog if it's still there
              },
              child: Text('Delete'),
            ),
          ],
        );

        return confirmationDialog;
      },
    );
  }
}
