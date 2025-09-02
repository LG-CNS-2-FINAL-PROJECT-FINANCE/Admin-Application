import 'package:admin_app/models/user.dart';
import 'package:flutter/material.dart';
import 'views/users_list.dart';
import 'views/reports_list.dart';
import 'views/posts_list.dart';

enum ManagementSection { users, reports, posts }

class ManagementTab extends StatefulWidget {
  const ManagementTab({super.key});
  @override
  State<ManagementTab> createState() => _ManagementTabState();
}

class _ManagementTabState extends State<ManagementTab> {
  final Color navy = const Color(0xFF0E2C4A);

  ManagementSection _section = ManagementSection.users; // ✅ 현재 섹션
  String _query = '';
  // ✅ 실제 사용자 리스트 (더미든, API든 여기서 관리)
  final List<User> _users = List.generate(
    20,
    (i) => User(
      name: '강만유 $i',
      nickname: '미니마니모$i',
      email: 'rlaalsdnl1$i@naver.com',
      dob: DateTime(1999, 3, 12),
      avatarAsset: 'assets/sample.jpeg', // 없으면 null 가능
    ),
  );

  @override
  Widget build(BuildContext context) {
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
              final size = MediaQuery.of(context).size;
              final top = kToolbarHeight + MediaQuery.of(context).padding.top;

              final selected = await showMenu<int>(
                context: context,
                position: RelativeRect.fromLTRB(size.width - 220, top, 16, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                items: const [
                  PopupMenuItem<int>(
                    enabled: false,
                    child: Text(
                      'Management',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 1,
                    child: _MenuRow(Icons.group, '사용자관리'),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: _MenuRow(Icons.flag_outlined, '신고관리'),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: _MenuRow(Icons.article_outlined, '프로젝트관리'),
                  ),
                ],
              );
              if (selected == null) return;

              setState(() {
                _query = ''; // 섹션 바꿀 때 검색어 초기화(선택)
                switch (selected) {
                  case 1:
                    _section = ManagementSection.users;
                    break;
                  case 2:
                    _section = ManagementSection.reports;
                    break;
                  case 3:
                    _section = ManagementSection.posts;
                    break;
                }
              });
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 섹션별 placeholder를 바꿔줌
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: _searchHint(_section), // ✅ 섹션별 힌트
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
              onChanged: (v) => setState(() => _query = v),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _sectionTitle(_section), // ✅ 섹션 타이틀
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(child: _buildBody(_section, _query)), // ✅ 섹션별 바디
        ],
      ),
    );
  }

  // ---- 섹션별 타이틀 / 힌트 / 바디 ----

  String _sectionTitle(ManagementSection s) => switch (s) {
    ManagementSection.users => '사용자 정보',
    ManagementSection.reports => '신고내역',
    ManagementSection.posts => '프로젝트',
  };

  String _searchHint(ManagementSection s) => switch (s) {
    ManagementSection.users => '사용자 검색',
    ManagementSection.reports => '신고내역 검색',
    ManagementSection.posts => '프로젝트 검색',
  };

  Widget _buildBody(ManagementSection s, String q) => switch (s) {
    ManagementSection.users => UsersList(query: q, users: _users), // ✅ 리스트 주입
    ManagementSection.reports => ReportsList(query: q),
    ManagementSection.posts => PostsList(query: q),
  };
}

// 메뉴 한 줄
class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MenuRow(this.icon, this.text, {super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [Icon(icon, size: 18), const SizedBox(width: 12), Text(text)],
  );
}
