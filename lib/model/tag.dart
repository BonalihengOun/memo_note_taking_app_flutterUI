import 'package:memo_note_app/model/userResponse.dart';

class Tag {
  final int tagId;
  final String tagName;
  final UserResponse users;

  Tag({required this.tagId, required this.tagName, required this.users});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tag_Id'],
      tagName: json['tagName'],
      users: UserResponse.fromJson(json['users']),
    );
  }

}
