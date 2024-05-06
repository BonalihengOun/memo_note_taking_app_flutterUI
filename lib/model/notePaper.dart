import 'package:flutter/material.dart';
import 'package:memo_note_app/model/tag.dart';
import 'package:memo_note_app/model/userResponse.dart';

import 'filesImgVideo.dart';

class Notepaper {
  final int notedId;
  final String title;
  final String note_content;
  final String note_description;
  final DateTime creationDate;
  final Color? selectColor;
  final String? selectColorHex;
  final List<Tag>? tagsLists;
  final List<ReceiveFile>? receiveFiles;
  final UserResponse users;
  late final bool isPinned;

  static const String defaultImagePath = 'lib/assets/backgroundDot.jpg';

  Notepaper({
    required this.notedId,
    required this.title,
    required this.note_content,
    required this.note_description,
    required this.creationDate,
    this.selectColor,
    this.isPinned = false,
    this.selectColorHex,
    this.tagsLists,
    this.receiveFiles,
    required this.users,
  });

  factory Notepaper.fromJson(Map<String, dynamic> json) {
    return Notepaper(
      notedId: json['notedId'] ?? 0,
      title: json['title'] ?? '',
      note_content: json['note_content'] ?? '',
      note_description: json['note_description'] ?? '',
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate']) ?? DateTime.now()
          : DateTime.now(),
      selectColor: _parseColor(json['selectColor']),
      selectColorHex: json['selectColor'] ?? null,
      tagsLists: (json['tagsLists'] as List<dynamic>?)
          ?.map((tagJson) => Tag.fromJson(tagJson))
          .toList(),
      receiveFiles: (json['receiveFiles'] as List<dynamic>?)
          ?.map((fileJson) => ReceiveFile.fromJson(fileJson))
          .toList(),
      users: UserResponse.fromJson(json['users'] ?? {}),
    );
  }

  static Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return null;
    } else if (colorString.startsWith('0x')) {
      return Color(int.parse(colorString));
    } else {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'notedId': notedId,
      'title': title,
      'note_content': note_content,
      'note_description': note_description,
      'creationDate': creationDate.toIso8601String(),
      'selectColor': selectColorHex,
      'tagsLists': tagsLists?.map((tag) => tag.toMap()).toList(),
      'receiveFiles': receiveFiles?.map((file) => file.toMap()).toList(),
      'users': users.toMap(),
    };
  }
}
