
class LoginResponse {
  final String? message;
  final Map<String, dynamic>? payload;
  final String? status;
  final String? creationDate;

  LoginResponse({
     this.message,
     this.payload,
     this.status,
     this.creationDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      payload: json['payload'] ?? {},
      status: json['status'] ?? '',
      creationDate: json['creationDate'] ?? '',
    );
  }

  int? get userId => payload?['userId'];
  String? get username => payload?['username'];
  String? get email => payload?['email'];
  String? get accessToken => payload?['accessToken'];




}
