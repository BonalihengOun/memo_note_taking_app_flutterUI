import 'package:memo_note_app/model/tag.dart';
import 'package:memo_note_app/model/userResponse.dart';

import 'filesImgVideo.dart';

class Notepaper {
  final int noteId; // Change 'notedId' to 'noteId'
  final String title;
  final String note_content; // Change 'noteContent' to 'note_content'
  final String note_description; // Change 'noteDescription' to 'note_description'
  final DateTime creationDate;
  final String selectColor;
  final List<Tag>? tagsLists;
  final List<ReceiveFile>? receiveFiles;
  final UserResponse users;

  Notepaper({
    required this.noteId,
    required this.title,
    required this.note_content,
    required this.note_description,
    required this.creationDate,
    required this.selectColor,
    required this.tagsLists,
    required this.receiveFiles,
    required this.users,
  });

  factory Notepaper.fromJson(Map<String, dynamic> json) {
    return Notepaper(
      noteId: json['notedId'],
      title: json['title'],
      note_content: json['note_content'],
      note_description: json['note_description'],
      creationDate: DateTime.parse(json['creationDate']),
      selectColor: json['selectColor'],
      tagsLists: List<Tag>.from((json['tagsLists'] ?? []).map((tagJson) => Tag.fromJson(tagJson))),
      receiveFiles: List<ReceiveFile>.from(json['receiveFiles'].map((fileJson) => ReceiveFile.fromJson(fileJson))),
      users: UserResponse.fromJson(json['users']),
    );
  }
}
