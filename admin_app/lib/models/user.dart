class User {
  final String name;
  final String nickname;
  final String email;
  final DateTime dob;
  final String? avatarAsset; // 없으면 null

  const User({
    required this.name,
    required this.nickname,
    required this.email,
    required this.dob,
    this.avatarAsset,
  });
}
