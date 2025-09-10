import 'package:admin_app/core/services/api_service.dart';
import 'package:admin_app/screens/login_screen.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2C4A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Settings for users',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),

          // Notifications
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
          ),
          const Divider(height: 1),

          // Theme
          ListTile(
            title: const Text('Theme'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 테마 선택 화면으로 이동하거나 다이얼로그 열기
            },
          ),
          const Divider(height: 1),

          // Log out
          ListTile(
            title: const Text('Log out'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // 선택: 정말 로그아웃할지 확인
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠어요?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              );
              if (ok != true) return;

              // 1) 로컬 토큰/만료시간 삭제
              try {
                // baseUrl은 앱 설정대로
                await AuthService(
                  ApiService("http://192.168.0.222:8080"),
                ).logout();

                // 2) (선택) 서버에 세션 무효화 API가 있으면 호출
                // await ApiService(AppConfig.baseUrl).post('/api/user/auth/logout', {});

                // 3) 로그인 화면으로 완전히 되돌리기 (스택 비우기)
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
              }
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
