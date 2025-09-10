import 'package:flutter/material.dart';
import 'package:admin_app/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectItem project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2C4A);
    const labelStyle = TextStyle(fontWeight: FontWeight.w700);

    final coverUrl = project.images.isNotEmpty ? project.images.first : null;
    final period =
        '${_fmtDate(project.startDate)} ~ ${_fmtDate(project.endDate)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 커버 이미지 =====
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: (coverUrl == null || coverUrl.isEmpty)
                    ? Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image,
                          size: 56,
                          color: Colors.grey,
                        ),
                      )
                    : Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // ===== 제목 =====
            const Text('Project Title', style: labelStyle),
            _readonlyField(project.title),
            const SizedBox(height: 12),

            // ===== 작성자 =====
            const Text('Author (Nickname)', style: labelStyle),
            _readonlyField(project.nickname.isEmpty ? '-' : project.nickname),
            const SizedBox(height: 12),

            // ===== 기간 / 마감 D-n =====
            const Text('Period', style: labelStyle),
            _readonlyField(period),
            const SizedBox(height: 12),

            const Text('Deadline (days)', style: labelStyle),
            _readonlyField('${project.deadline}'),
            const SizedBox(height: 12),

            // ===== 금액/달성률 =====
            const Text('Amount (KRW)', style: labelStyle),
            _readonlyField(_formatCurrency(project.amount)),
            const SizedBox(height: 12),

            const Text('Progress', style: labelStyle),
            const SizedBox(height: 8),
            _ProgressBar(percent: project.percent),
            const SizedBox(height: 4),
            Text(
              '${project.percent}%',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // ===== 식별자 =====
            const Text('Project ID', style: labelStyle),
            _readonlyField(project.projectId),
            const SizedBox(height: 12),

            const Text('User Seq', style: labelStyle),
            _readonlyField(project.userSeq),

            const SizedBox(height: 24),

            // ===== 하단 버튼들 (필요 시 API 연결) =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 숨김처리 API
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // yyyy.MM.dd
  static String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  // 읽기 전용 필드
  static Widget _readonlyField(
    String value, {
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      minLines: minLines,
      maxLines: maxLines,
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

  // 12,345,678
  static String _formatCurrency(num value) {
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buf.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

class _ProgressBar extends StatelessWidget {
  final int percent; // 0~100
  const _ProgressBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final v = percent.clamp(0, 100) / 100.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: v,
        minHeight: 10,
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }
}
