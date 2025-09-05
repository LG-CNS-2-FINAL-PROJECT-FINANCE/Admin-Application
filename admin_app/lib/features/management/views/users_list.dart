import 'package:admin_app/features/management/screens/user_detail_screen.dart';
import 'package:admin_app/features/management/widgets/square_thumb.dart';
import 'package:admin_app/models/user.dart';
import 'package:flutter/material.dart';

// 사용자관리
class UsersList extends StatelessWidget {
  final String query;
  final List<User> users;

  const UsersList({super.key, required this.query, required this.users});

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final filtered = users
        .where(
          (u) =>
              u.name.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q) ||
              u.nickname.toLowerCase().contains(q),
        )
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final user = filtered[i];
        return ListTile(
          leading: SquareThumb(
            image: user.avatarAsset != null
                ? AssetImage(user.avatarAsset!)
                : null,
            fallback: Center(
              child: Text(
                user.name.characters.first,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            user.email,
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            );
          },
        );
      },
    );
  }
}
