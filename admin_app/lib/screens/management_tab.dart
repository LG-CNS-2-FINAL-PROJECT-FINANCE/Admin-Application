import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ManagementTab extends StatefulWidget {
  const ManagementTab({super.key});
  @override
  State<ManagementTab> createState() => _ManagementTabState();
}

class _ManagementTabState extends State<ManagementTab> {
  final _users = List.generate(20, (i) => ('강만유', 'rlaalsdnl1$i@naver.com'));

  String _query = ''; // 검색어

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2C4A);

    // 검색어에 따라 필터링된 리스트
    final filteredUsers = _users
        .where(
          (u) =>
              u.$1.toLowerCase().contains(_query.toLowerCase()) ||
              u.$2.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Management',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () async {
              final overlayBox =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final pos = RelativeRect.fromLTRB(
                overlayBox.size.width,
                kToolbarHeight,
                16,
                0,
              );

              final selected = await showMenu<int>(
                context: context,
                position: pos,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                items: <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    enabled: false,
                    child: Text(
                      'Management',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.group, size: 18),
                        SizedBox(width: 12),
                        Text('사용자관리'),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(Icons.flag_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('신고관리'),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      children: const [
                        Icon(Icons.article_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('게시물관리'),
                      ],
                    ),
                  ),
                ],
              );

              // 선택 처리
              switch (selected) {
                case 1:
                  // TODO: 사용자관리 화면으로 이동
                  break;
                case 2:
                  // TODO: 신고관리 화면으로 이동
                  break;
                case 3:
                  // TODO: 게시물관리 화면으로 이동
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '이름 또는 이메일 검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          // 리스트
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              itemCount: filteredUsers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final (name, email) = filteredUsers[i];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/sample.jpeg',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: Text(
                          name.characters.first,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    email,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem _menuItem(IconData icon, String text, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 12), Text(text)],
      ),
    );
  }
}
