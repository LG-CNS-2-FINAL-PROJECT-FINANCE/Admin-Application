// lib/features/management/views/reports_list.dart
import 'package:flutter/material.dart';
import 'package:admin_app/models/report.dart';
import 'package:admin_app/features/management/services/monitoring_service.dart';
import 'package:admin_app/features/management/screens/report_detail_screen.dart';

class ReportsList extends StatefulWidget {
  final String query;
  const ReportsList({super.key, required this.query});

  @override
  State<ReportsList> createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  final _svc = MonitoringService();
  late Future<List<ReportItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.fetchReports();
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.query.toLowerCase();

    return FutureBuilder<List<ReportItem>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('오류: ${snap.error}'));
        }

        final items = snap.data ?? const [];
        final filtered = items.where((r) {
          return r.title.toLowerCase().contains(q) ||
              r.reportNickname.toLowerCase().contains(q) ||
              r.writerNickname.toLowerCase().contains(q);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final r = filtered[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: const Icon(Icons.report, color: Colors.indigo),
              ),
              title: Text(
                r.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '신고자: ${r.reportNickname}  •  대상: ${r.writerNickname}',
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(r.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  r.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: _statusColor(r.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportDetailScreen(report: r),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
