// lib/models/user.dart
class User {
  final String userSeq;
  final String? email;
  final String nickname;
  final String role;
  final int? age;
  final String? gender;
  final String status;
  final DateTime? latestAt;

  const User({
    required this.userSeq,
    this.email,
    required this.nickname,
    required this.role,
    this.age,
    this.gender,
    required this.status,
    this.latestAt,
  });

  factory User.fromJson(Map<String, dynamic> j) {
    return User(
      userSeq: j['userSeq'] as String,
      email: j['email'] as String?,
      nickname: j['nickname'] as String? ?? '',
      role: j['role'] as String? ?? '',
      age: j['age'] == null ? null : int.tryParse(j['age'].toString()),
      gender: j['gender'] as String?,
      status: j['status'] as String? ?? '',
      latestAt: j['latestAt'] != null
          ? DateTime.tryParse(j['latestAt'].toString())
          : null,
    );
  }
}
