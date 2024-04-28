import 'package:memo_note_app/model/userResponse.dart';

class Tag {
  final int tagId;
  final String tagName;
  final UserResponse users;

  Tag({
    required this.tagId,
    required this.tagName,
    required this.users,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tagId'] as int,
      tagName: json['tagName'] as String,
      users: UserResponse.fromJson(json['users'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
      'users': users.toJson(),
    };
  }
}