class UserDetail {
  final int userId;
  final String username;
  final String name;
  final String email;
  final String password;
  final bool enabled;
  final bool credentialsNonExpired;
  final List<Authority> authorities;
  final bool accountNonExpired;
  final bool accountNonLocked;

  UserDetail({
    required this.userId,
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.enabled,
    required this.credentialsNonExpired,
    required this.authorities,
    required this.accountNonExpired,
    required this.accountNonLocked,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      userId: json['userId'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      enabled: json['enabled'],
      credentialsNonExpired: json['credentialsNonExpired'],
      authorities: List<Authority>.from(
          json['authorities'].map((authority) => Authority.fromJson(authority))),
      accountNonExpired: json['accountNonExpired'],
      accountNonLocked: json['accountNonLocked'],
    );
  }
}

class Authority {
  final String authority;

  Authority({required this.authority});

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(authority: json['authority']);
  }
}
