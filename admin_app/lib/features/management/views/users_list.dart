import 'package:admin_app/features/management/screens/user_detail_screen.dart';
import 'package:admin_app/models/user.dart';
import 'package:flutter/material.dart';

// 사용자관리
class UsersList extends StatelessWidget {
  final String query;
  final List<User> users;
  final ValueChanged<User>? onUserUpdated;

  const UsersList({
    super.key,
    required this.query,
    required this.users,
    this.onUserUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final filtered = users.where((u) {
      final nick = u.nickname.toLowerCase();
      final email = (u.email ?? '').toLowerCase();
      final role = u.role.toLowerCase();
      final status = u.status.toLowerCase();
      return nick.contains(q) ||
          email.contains(q) ||
          role.contains(q) ||
          status.contains(q);
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final user = filtered[i];

        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              (user.nickname.isNotEmpty ? user.nickname.characters.first : '?')
                  .toUpperCase(),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            user.nickname,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            user.email ?? '(이메일 없음)',
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.role,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                user.status,
                style: TextStyle(
                  fontSize: 12,
                  color: () {
                    switch (user.status.toUpperCase()) {
                      case 'ACTIVE':
                        return Colors.green;
                      case 'DISABLED':
                        return Colors.black87;
                      case 'DELETED':
                        return Colors.red;
                      default:
                        return Colors.grey; // 혹시 모를 예외
                    }
                  }(),
                ),
              ),
            ],
          ),
          onTap: () async {
            final updated = await Navigator.push<User>(
              context,
              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            );
            if (updated != null) {
              onUserUpdated?.call(updated); // ✅ 부모에게 알림
            }
          },
        );
      },
    );
  }
}
