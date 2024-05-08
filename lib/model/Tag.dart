import 'package:memo_note_app/model/userResponse.dart';

class Tag {
  final int tagId;
  final String tagName;
  final UserResponse? users;

  Tag({required this.tagId, required this.tagName,  this.users});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tag_Id'] ?? 0,
      tagName: json['tagName'] ?? '',
      users: UserResponse.fromJson(json['users'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tag_Id': tagId,
      'tagName': tagName,
    };
  }

}
