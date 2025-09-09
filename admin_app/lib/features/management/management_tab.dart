import 'dart:convert';

import 'package:admin_app/core/config/app_config.dart';
import 'package:admin_app/core/services/api_service.dart';
import 'package:admin_app/models/user.dart';
import 'package:flutter/material.dart';
import 'views/users_list.dart';
import 'views/reports_list.dart';
import 'views/projects_request_list.dart';
import 'views/projects_list.dart';

enum ManagementSection { users, reports, posts, projects }

class ManagementTab extends StatefulWidget {
  const ManagementTab({super.key});
  @override
  State<ManagementTab> createState() => _ManagementTabState();
}

class _ManagementTabState extends State<ManagementTab> {
  final Color navy = const Color(0xFF0E2C4A);
  final ApiService api = ApiService(AppConfig.baseUrl); // ✅ ApiService 주입

  ManagementSection _section = ManagementSection.users; // ✅ 현재 섹션
  String _query = '';

  List<User> _users = [];
  bool _loadingUsers = false;
  String? _usersError;
  // ✅ 실제 사용자 리스트 (더미든, API든 여기서 관리)
  @override
  void initState() {
    super.initState();
    _loadUsers(); // 시작하자마자 불러오기
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loadingUsers = true;
      _usersError = null;
    });
    try {
      final res = await api.get('/api/user/list'); // 토큰 자동 첨부
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        // 응답 형태에 맞게 파싱: 배열 또는 {data:[...]}
        final List list = (decoded is Map && decoded['data'] is List)
            ? decoded['data'] as List
            : (decoded as List);

        final users = list
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          _users = users;
        });
      } else if (res.statusCode == 401) {
        setState(() => _usersError = '인증이 만료되었습니다. 다시 로그인 해주세요.');
      } else {
        setState(() => _usersError = '불러오기에 실패했습니다 (${res.statusCode})');
      }
    } catch (e) {
      setState(() => _usersError = '네트워크 오류: $e');
    } finally {
      if (mounted) setState(() => _loadingUsers = false);
    }
  }

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
                    child: _MenuRow(Icons.article_outlined, '프로젝트요청관리'),
                  ),
                  PopupMenuItem<int>(
                    value: 4,
                    child: _MenuRow(Icons.folder_open, '프로젝트관리'),
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
                  case 4:
                    _section = ManagementSection.projects;
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
    ManagementSection.posts => '프로젝트 요청',
    ManagementSection.projects => '프로젝트',
  };

  String _searchHint(ManagementSection s) => switch (s) {
    ManagementSection.users => '사용자 검색',
    ManagementSection.reports => '신고내역 검색',
    ManagementSection.posts => '프로젝트 요청 검색',
    ManagementSection.projects => '프로젝트 검색',
  };

  Widget _buildBody(ManagementSection s, String q) => switch (s) {
    ManagementSection.users => UsersList(
      query: q,
      users: _users,
      onUserUpdated: (updated) {
        setState(() {
          final idx = _users.indexWhere((u) => u.userSeq == updated.userSeq);
          if (idx != -1) {
            _users[idx] = updated; // ✅ 리스트 내 해당 유저 대체
          }
        });
      },
    ), // ✅ 리스트 주입
    ManagementSection.reports => ReportsList(query: q),
    ManagementSection.posts => ProjectsRequestList(query: q),
    ManagementSection.projects => ProjectsList(query: q),
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
