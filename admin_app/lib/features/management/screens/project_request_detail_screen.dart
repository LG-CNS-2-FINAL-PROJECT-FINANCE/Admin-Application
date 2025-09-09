import 'package:admin_app/features/management/services/project_service.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/models/project_request.dart';

class ProjectRequestDetailScreen extends StatelessWidget {
  final ProjectRequestItem project;
  const ProjectRequestDetailScreen({super.key, required this.project});
  static final ProjectService _svc = ProjectService();
  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontWeight: FontWeight.w700);
    const navy = Color(0xFF0E2C4A);

    final coverUrl = project.images.isNotEmpty ? project.images.first : null;
    final period =
        '${_fmtDate(project.startDate)} ~ ${_fmtDate(project.endDate)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Request'),
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

            // ===== 작성자 / 요청 타입 =====
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Author (Nickname)', style: labelStyle),
                      _readonlyField(
                        project.nickname.isEmpty ? '-' : project.nickname,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Request Type', style: labelStyle),
                      _readonlyField(
                        project.requestType,
                      ), // CREATE/UPDATE/DELETE …
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ===== 기간 =====
            const Text('Period', style: labelStyle),
            _readonlyField(period),
            const SizedBox(height: 12),

            // ===== 상태 =====
            const Text('Request Status', style: labelStyle),
            _readonlyField(
              project.requestStatus,
            ), // PENDING/APPROVED/REJECTED …
            const SizedBox(height: 12),

            // ===== 식별자 =====
            const Text('Request ID', style: labelStyle),
            _readonlyField(project.requestId),
            const SizedBox(height: 12),

            const Text('User Seq', style: labelStyle),
            _readonlyField(project.userSeq),
            const SizedBox(height: 12),

            const Text('Project ID', style: labelStyle),
            _readonlyField(project.projectId ?? '-'),
            const SizedBox(height: 24),

            // ===== 하단 버튼들 =====
            // 실제 승인/거절/숨김 API 붙일 때 이 onPressed 내부만 채우면 됨
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final ok = await _svc.approveProjectRequest(
                          requestId: project.requestId,
                        );
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('승인되었습니다.')),
                          );
                          Navigator.pop(context, true); // 리스트 갱신용
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('승인 실패: $e')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
                    onPressed: () async {
                      try {
                        final ok = await _svc.rejectProjectRequest(
                          requestId: project.requestId,
                        );
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('거절되었습니다.')),
                          );
                          Navigator.pop(context, true); // 리스트 갱신용
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('거절 실패: $e')));
                      }
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
}
