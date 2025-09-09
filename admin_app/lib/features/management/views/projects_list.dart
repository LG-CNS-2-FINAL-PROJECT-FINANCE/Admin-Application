import 'package:admin_app/features/management/screens/project_detail_screen.dart';
import 'package:admin_app/models/project.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/features/management/services/project_service.dart';

class ProjectsList extends StatefulWidget {
  final String query;
  const ProjectsList({super.key, required this.query});

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  final _svc = ProjectService();
  late Future<List<ProjectItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.query.toLowerCase();

    return FutureBuilder<List<ProjectItem>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('오류: ${snap.error}'));
        }
        final items = snap.data ?? const [];

        // 검색: 제목/닉네임 기준
        final filtered = items.where((p) {
          return p.title.toLowerCase().contains(q) ||
              p.nickname.toLowerCase().contains(q);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = filtered[i];
            final thumbUrl = p.images.isNotEmpty ? p.images.first : null;

            return ListTile(
              leading: _SquareThumbNetwork(url: thumbUrl),
              title: Text(
                p.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'Author : ${p.nickname}',
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // ✅ 방법 A: ProjectDetailScreen이 새 모델(ProjectItem)을 받도록 수정
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectDetailScreen(project: p),
                  ),
                );

                // ✅ 방법 B: 만약 기존 Detail이 예전 모델을 받는다면,
                //           여기서 매핑(어댑터)을 해서 넘겨주세요.
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (_) => OldDetailScreen(project: _mapToOldProject(p)),
                // ));
              },
            );
          },
        );
      },
    );
  }
}

/// 네트워크 사각 썸네일 (fallback 포함)
class _SquareThumbNetwork extends StatelessWidget {
  final String? url;
  const _SquareThumbNetwork({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        color: Colors.grey.shade300,
        child: (url == null || url!.isEmpty)
            ? const Icon(Icons.image, color: Colors.white)
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.white),
              ),
      ),
    );
  }
}
