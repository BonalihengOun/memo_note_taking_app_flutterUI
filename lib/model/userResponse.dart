

class UserResponse {
  final int userId;
  final String username;
  final String email;


  UserResponse({
    required this.userId,
    required this.username,
    required this.email,

  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
 
    };
  }
}
