class UserResponse {
  final int userId;
  final String username;
  final String email;

  UserResponse(
      {required this.userId, required this.username, required this.email});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
    };
  }
}
