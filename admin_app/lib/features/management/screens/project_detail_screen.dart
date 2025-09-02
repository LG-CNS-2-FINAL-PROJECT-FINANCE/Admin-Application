import 'package:flutter/material.dart';
import '../../../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontWeight: FontWeight.w700);
    const navy = Color(0xFF0E2C4A);

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
            // 커버 이미지
            if (project.imageAsset != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  project.imageAsset!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 56, color: Colors.grey),
              ),
            const SizedBox(height: 24),

            // 프로젝트명
            const Text('Project Name', style: labelStyle),
            _readonlyField(project.name),
            const SizedBox(height: 12),

            // 시작/종료일
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('StartAt', style: labelStyle),
                      _readonlyField(_fmtDate(project.startAt)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EndAt', style: labelStyle),
                      _readonlyField(_fmtDate(project.endAt)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 상태, 종류
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Status', style: labelStyle),
                      _readonlyField(project.status),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kinds', style: labelStyle),
                      _readonlyField(project.kind),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 요약
            const Text('Summary', style: labelStyle),
            _readonlyField(project.summary, minLines: 3, maxLines: 5),
            const SizedBox(height: 12),

            // 프로젝트ID, 사용자ID
            const Text('ProjectId', style: labelStyle),
            _readonlyField(project.projectId),
            const SizedBox(height: 12),
            const Text('UserId', style: labelStyle),
            _readonlyField(project.userId),
            const SizedBox(height: 12),

            // 목표/최소금액
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Goal', style: labelStyle),
                      _readonlyField('${_formatCurrency(project.goal)} 원'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Minimum', style: labelStyle),
                      _readonlyField('${_formatCurrency(project.minimum)} 원'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 파일 목록
            const Text('Files', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: project.files.length,
                itemBuilder: (_, index) {
                  final file = project.files[index];
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file_outlined),
                    title: Text(file.name),
                    trailing: const Icon(Icons.download_rounded),
                    onTap: () {
                      // 다운로드 처리 필요시 구현
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 하단 버튼들
            SizedBox(
              width: double.infinity, // or a fixed width if you prefer
              child: ElevatedButton(
                onPressed: () {
                  // 숨김처리 동작 구현
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
                      // 승인 버튼 클릭 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                      // 거절 버튼 클릭 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('거절'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // 날짜 형식 변환: yyyy.MM.dd
  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  // 읽기 전용 필드 위젯
  Widget _readonlyField(String value, {int minLines = 1, int maxLines = 1}) {
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

  // 세 자리마다 쉼표 넣기
  String _formatCurrency(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buffer.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}
