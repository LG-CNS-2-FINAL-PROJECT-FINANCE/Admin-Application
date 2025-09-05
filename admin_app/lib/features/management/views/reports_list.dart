import 'package:admin_app/features/management/screens/report_detail_screen.dart';
import 'package:admin_app/features/management/widgets/square_thumb.dart';
import 'package:admin_app/models/report.dart';
import 'package:flutter/material.dart';

class ReportsList extends StatelessWidget {
  final String query;
  const ReportsList({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터: 실제로는 서버에서 받아올 수 있습니다.
    final reports = List.generate(
      20,
      (i) => Report(
        projectName: '프로젝트 A',
        reporter: '감만유 $i',
        owner: '구민',
        status: 'REPORTED',
        kind: 'NOJAM',
        description: 'Summary...',
        imageAsset: 'assets/sample.jpeg',
      ),
    );

    // 검색 필터링
    final filtered = reports.where((r) {
      return r.projectName.toLowerCase().contains(query.toLowerCase()) ||
          r.reporter.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final report = filtered[i];
        return ListTile(
          leading: SquareThumb(
            image: AssetImage(report.imageAsset),
            fallback: const Icon(Icons.image, color: Colors.white),
          ),
          title: Text(
            report.projectName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            '신고사유 : ${report.kind}',
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportDetailScreen(report: report),
              ),
            );
          },
        );
      },
    );
  }
}
