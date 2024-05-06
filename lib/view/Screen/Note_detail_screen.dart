import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/share_preferrences.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Share_preferences _prefs = Share_preferences();
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F5EC),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,left: 15,right: 15),
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
                        color: Color(0xff8718DF)),
                    child: IconButton(
                      icon: const Image(
                        image: AssetImage("lib/assets/left_back.png"),
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
                        color: Color(0xff8718DF)),
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

        ],
      ),
    );
  }
}
