// lib/features/management/screens/report_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:admin_app/models/report.dart';

class ReportDetailScreen extends StatelessWidget {
  final ReportItem report;
  const ReportDetailScreen({super.key, required this.report});

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
    const navy = Color(0xFF0E2C4A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Report Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 썸네일(이미지 없음 -> 아이콘)
            Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.report_gmailerrorred,
                color: Colors.red.shade400,
                size: 56,
              ),
            ),
            const SizedBox(height: 24),

            _Label('Title'),
            _ReadonlyField(report.title),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Report Type'),
                      _ReadonlyField(report.reportType), // USER / PROJECT ...
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_Label('Status'), _ReadonlyField(report.status)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Reporter (Nickname)'),
                      _ReadonlyField(report.reportNickname),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Target Writer (Nickname)'),
                      _ReadonlyField(report.writerNickname),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _Label('Project ID'),
            _ReadonlyField(report.projectId),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Report ID'),
                      _ReadonlyField(report.reportId),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Report No'),
                      _ReadonlyField('${report.reportNo}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 하단 액션 (예시 — API 붙이기 전)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 숨김 처리 API
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('숨김처리'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 승인 API
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _statusColor('APPROVED').withOpacity(.9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('승인'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 보류/거절 API
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('보류'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w700));
}

class _ReadonlyField extends StatelessWidget {
  final String value;
  final bool obscure;
  final TextInputType? keyboardType;
  final int? minLines;
  const _ReadonlyField(
    this.value, {
    this.obscure = false,
    this.keyboardType,
    this.minLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      obscureText: obscure,
      keyboardType: keyboardType,
      minLines: minLines ?? 1,
      maxLines: minLines ?? 1,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
