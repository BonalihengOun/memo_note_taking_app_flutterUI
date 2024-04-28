
import 'package:memo_note_app/model/FilesImgVideo.dart';
import 'package:memo_note_app/model/tag.dart';
import 'package:memo_note_app/model/userResponse.dart';

class NotePaper {
  final int notedId;
  final String title;
  final String noteContent;
  final String noteDescription;
  final DateTime creationDate;
  final String selectColor;
  final List<Tag> tagsLists;
  final List<FilesImgVideo> receiveFiles;
  final UserResponse users;


   NotePaper({
    required this.notedId,
    required this.title,
    required this.noteContent,
    required this.noteDescription,
    required this.creationDate,
    required this.selectColor,
    required this.tagsLists,
    required this.receiveFiles,
    required this.users,
  });

  factory NotePaper.fromJson(Map<String, dynamic> json) {
    return NotePaper(
      notedId: json['notedId'] as int,
      title: json['title'] as String,
      noteContent: json['noteContent'] as String,
      noteDescription: json['noteDescription'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      selectColor: json['selectColor'] as String,
      tagsLists: (json['tagsLists'] as List<dynamic>)
          .map((tagJson) => Tag.fromJson(tagJson as Map<String, dynamic>))
          .toList(),
      receiveFiles: (json['receiveFiles'] as List<dynamic>)
          .map((fileJson) =>
              FilesImgVideo.fromJson(fileJson as Map<String, dynamic>))
          .toList(),
      users: UserResponse.fromJson(json['users'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notedId': notedId,
      'title': title,
      'noteContent': noteContent,
      'noteDescription': noteDescription,
      'creationDate': creationDate.toIso8601String(),
      'selectColor': selectColor,
      'tagsLists': tagsLists.map((tag) => tag.toJson()).toList(),
      'receiveFiles': receiveFiles.map((file) => file.toJson()).toList(),
      'users': users.toJson(),
    };
  }
}


