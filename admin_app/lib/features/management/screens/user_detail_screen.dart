import 'package:admin_app/core/services/api_service.dart';
import 'package:admin_app/models/user.dart';
import 'package:admin_app/theme/colors.dart';
import 'package:admin_app/core/config/app_config.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late User _user; // 화면에 표시/갱신할 현재 사용자
  late final ApiService _api = ApiService(AppConfig.baseUrl);
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _updateStatus({
    required String endpoint, // 예: '/api/user/disabled'
    required String newStatus, // 'ACTIVE' | 'DISABLED' | 'DELETED'
  }) async {
    if (_submitting) return;
    setState(() => _submitting = true);

    try {
      // ✅ 쿼리 파라미터를 URL에 붙여서 POST (body는 빈 객체)
      final userSeqEnc = Uri.encodeComponent(_user.userSeq);
      final statusEnc = Uri.encodeComponent(newStatus);
      final urlWithQuery =
          '$endpoint?userSeq=$userSeqEnc&user_status=$statusEnc';

      final res = await _api.post(urlWithQuery, const {}); // body 없음

      if (res.statusCode == 200) {
        setState(() {
          _user = User(
            userSeq: _user.userSeq,
            email: _user.email,
            nickname: _user.nickname,
            role: _user.role,
            age: _user.age,
            gender: _user.gender,
            status: newStatus,
            latestAt: DateTime.now(),
          );
        });
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('상태가 $newStatus(으)로 변경되었습니다.')));
        Navigator.pop(context, _user);
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('인증 만료. 다시 로그인 해주세요.')));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('변경 실패 (${res.statusCode})')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('네트워크 오류: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDateTime(_user.latestAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필(닉네임 이니셜)
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: Colors.black12,
                child: Text(
                  (_user.nickname.isNotEmpty
                          ? _user.nickname.characters.first
                          : '?')
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _Label('User ID'),
            _ReadonlyField(_user.userSeq),
            const SizedBox(height: 12),

            _Label('Nickname'),
            _ReadonlyField(_user.nickname),
            const SizedBox(height: 12),

            _Label('Email'),
            _ReadonlyField(
              _user.email ?? '-',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            _Label('Role'),
            _ReadonlyField(_user.role),
            const SizedBox(height: 12),

            _Label('Status'),
            _ReadonlyField(_user.status),
            const SizedBox(height: 12),

            _Label('Latest Activity'),
            _ReadonlyField(dateText ?? '-'),
            const SizedBox(height: 24),

            // ===== 액션 버튼들 =====
            // ===== 액션 버튼들 =====
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                children: [
                  // 활성화 버튼
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _submitting || _user.status == 'ACTIVE'
                          ? null
                          : () => _updateStatus(
                              endpoint: '/api/user/active',
                              newStatus: 'ACTIVE',
                            ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.green.shade600),
                        foregroundColor: Colors.green.shade700,
                      ),
                      child: const Text('활성화'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 비활성화 버튼
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _submitting || _user.status == 'DISABLED'
                          ? null
                          : () => _updateStatus(
                              endpoint: '/api/user/disabled',
                              newStatus: 'DISABLED',
                            ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.orange.shade600),
                        foregroundColor: Colors.orange.shade700,
                      ),
                      child: const Text('비활성화'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 정지 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitting || _user.status == 'DELETED'
                          ? null
                          : () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('정지 처리'),
                                  content: const Text(
                                    '해당 사용자를 정지(DELETED) 처리하시겠어요?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('취소'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('확인'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                _updateStatus(
                                  endpoint: '/api/user/deleted',
                                  newStatus: 'DELETED',
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('정지'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _formatDateTime(DateTime? dt) {
    if (dt == null) return null;
    return '${dt.year}-${_2(dt.month)}-${_2(dt.day)} ${_2(dt.hour)}:${_2(dt.minute)}';
  }

  String _2(int v) => v.toString().padLeft(2, '0');
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
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
