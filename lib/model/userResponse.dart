class UserResponse {
  final int? userId;
  final String? name;
  final String? email;

  UserResponse(
      { this.userId,  this.name,  this.email});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
    };
  }
}
