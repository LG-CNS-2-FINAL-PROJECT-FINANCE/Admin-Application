import 'package:flutter/material.dart';
import 'package:admin_app/features/management/widgets/square_thumb.dart';
import 'package:admin_app/features/management/screens/project_detail_screen.dart';
import 'package:admin_app/models/project.dart';

class PostsList extends StatelessWidget {
  final String query;
  const PostsList({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // 샘플 프로젝트 데이터
    final projects = List<Project>.generate(
      20,
      (i) => Project(
        name: '프로젝트 ${i + 1}',
        startAt: DateTime(2025, 2, 2),
        endAt: DateTime(2025, 2, 18),
        status: 'APPROVED',
        kind: 'CREATE',
        summary: '요약 설명 ${i + 1}',
        projectId: 'project-id-${i + 1}',
        userId: 'user-id-${i + 1}',
        goal: 20000000,
        minimum: 1000,
        imageAsset: 'assets/sample.jpeg',
        files: const [
          ProjectFile(name: '기획 보고서'),
          ProjectFile(name: '사업 계획서'),
          ProjectFile(name: '기업 재무제표'),
          ProjectFile(name: '기업 실적 보고서'),
        ],
      ),
    );

    // 검색어 필터
    final filtered = projects.where((p) {
      final lower = query.toLowerCase();
      return p.name.toLowerCase().contains(lower) ||
          p.summary.toLowerCase().contains(lower);
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final project = filtered[i];
        return ListTile(
          leading: SquareThumb(
            image: project.imageAsset != null
                ? AssetImage(project.imageAsset!)
                : null,
            fallback: const Icon(Icons.image, color: Colors.white),
          ),
          title: Text(
            project.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            'Author : ${project.userId}', // 필요하다면 실제 작성자 이름으로 변경
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProjectDetailScreen(project: project),
              ),
            );
          },
        );
      },
    );
  }
}
