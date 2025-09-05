import 'package:admin_app/models/user.dart';
import 'package:admin_app/theme/colors.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontWeight: FontWeight.w700);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          children: [
            // 프로필 이미지
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.black12,
              child: ClipOval(
                child: user.avatarAsset != null
                    ? Image.asset(
                        user.avatarAsset!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        // 에셋 못 찾으면 이니셜로 대체
                        errorBuilder: (_, __, ___) => _initials(user.name),
                      )
                    : _initials(user.name),
              ),
            ),
            const SizedBox(height: 32),

            // Name
            _Label('Name'),
            _ReadonlyField(user.name),
            const SizedBox(height: 12),

            // Nickname
            _Label('Nickname'),
            _ReadonlyField(user.nickname),
            const SizedBox(height: 12),

            // Email
            _Label('Email'),
            _ReadonlyField(
              user.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            // Password (가짜 표시만, 실제 비번 노출 금지)
            _Label('Password'),
            _ReadonlyField('****************', obscure: true),
            const SizedBox(height: 12),

            // Date of Birth
            _Label('Date of Birth'),
            _ReadonlyField(_formatDate(user.dob)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.month}/${d.day}/${d.year}';
  Widget _initials(String name) => Container(
    width: 88,
    height: 88,
    alignment: Alignment.center,
    color: Colors.grey.shade300,
    child: Text(
      name.characters.first,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    ),
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}

class _ReadonlyField extends StatelessWidget {
  final String value;
  final bool obscure;
  final TextInputType? keyboardType;
  const _ReadonlyField(
    this.value, {
    this.obscure = false,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
