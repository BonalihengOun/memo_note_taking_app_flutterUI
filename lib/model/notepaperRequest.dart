import 'package:flutter/material.dart';
import 'package:memo_note_app/model/Tag.dart';

import 'filesImgVideo.dart';

class NotepaperRequest {
  final int? notedId;
  final String title;
  final String note_content;
  final String note_description;
  final DateTime creationDate;
  final Color? selectColor;
  final List<int>? tagsLists;
  final List<ReceiveFile>? receiveFiles;

  static const String defaultImagePath = 'lib/assets/backgroundDot.jpg';


  NotepaperRequest({
    this.notedId,
    required this.title,
    required this.note_content,
    required this.note_description,
    required this.creationDate,
    this.selectColor,
    this.tagsLists,
    this.receiveFiles,

  });

  factory NotepaperRequest.fromJson(Map<String, dynamic> json) {
    return NotepaperRequest(
      title: json['title'] ?? '',
      note_content: json['note_content'] ?? '',
      note_description: json['note_description'] ?? '',
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate']) ?? DateTime.now()
          : DateTime.now(),
      selectColor: _parseColor(json['selectColor']),
      tagsLists: (json['tagsLists'] as List<dynamic>?)?.cast<int>(), // Cast the list to integers
      receiveFiles: (json['receiveFiles'] as List<dynamic>?)
          ?.map((fileJson) => ReceiveFile.fromJson(fileJson))
          .toList(),
    );
  }

  static Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return null;
    } else if (colorString.startsWith('0xff')) {
      return Color(int.parse(colorString));
    } else {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note_content': note_content,
      'note_description': note_description,
      'creationDate': creationDate.toIso8601String(),
      'selectColor': selectColor != null ? '0xff${_colorToHex(selectColor!)}' : null,
      'tagsLists': tagsLists,
      'receiveFiles': receiveFiles?.map((file) => file.toMap()).toList(),
    };
  }

  static String _colorToHex(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0');
  }
}
