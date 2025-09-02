import 'package:admin_app/models/report.dart';
import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;
  const ReportDetailScreen({super.key, required this.report});

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
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: report.imageAsset != null
                  ? Image.asset(
                      report.imageAsset,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.shade300,
                    ),
            ),
            const SizedBox(height: 24),

            // Project Name
            _Label('Project Name'),
            _ReadonlyField(report.projectName),
            const SizedBox(height: 16),

            // Reporter / Owner
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Reporter'),
                      _ReadonlyField(report.reporter),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_Label('Owner'), _ReadonlyField(report.owner)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status / Kinds
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_Label('Status'), _ReadonlyField(report.status)],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_Label('Kinds'), _ReadonlyField(report.kind)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            _Label('Description'),
            _ReadonlyField(report.description, minLines: 3),
            const SizedBox(height: 24),

            // 숨김처리 버튼 (가로 전체)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 숨김처리 로직
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

            // 승인 / 보류 버튼 나란히
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 승인 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('승인'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 보류 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
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
          ],
        ),
      ),
    );
  }
}

// 공통 위젯들
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w700));
  }
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
      minLines: minLines,
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
