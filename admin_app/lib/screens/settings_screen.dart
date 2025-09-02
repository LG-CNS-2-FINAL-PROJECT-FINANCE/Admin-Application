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
              // TODO: 로그아웃 처리 (토큰 삭제/세션 종료 등)
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
