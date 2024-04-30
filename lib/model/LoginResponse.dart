class LoginResponse {
  final String message;
  final Map<String, dynamic> payload;
  final String status;
  final String creationDate;

  LoginResponse({
    required this.message,
    required this.payload,
    required this.status,
    required this.creationDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      payload: json['payload'] ?? {},
      status: json['status'] ?? '',
      creationDate: json['creationDate'] ?? '',
    );
  }

  String? get accessToken => payload['accessToken'];

// Add other fields or methods as needed
}
