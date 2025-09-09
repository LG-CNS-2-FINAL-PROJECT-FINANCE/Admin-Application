// lib/models/report.dart
class ReportItem {
  final int reportNo;
  final String projectId;
  final String title;
  final String reportId;
  final String reportNickname; // 신고자 닉네임
  final String writerId; // 피신고자(작성자) ID
  final String writerNickname; // 피신고자 닉네임
  final String reportType; // 예: USER, PROJECT ...
  final String status; // 예: SUBMITTED, APPROVED ...

  const ReportItem({
    required this.reportNo,
    required this.projectId,
    required this.title,
    required this.reportId,
    required this.reportNickname,
    required this.writerId,
    required this.writerNickname,
    required this.reportType,
    required this.status,
  });

  factory ReportItem.fromJson(Map<String, dynamic> j) {
    return ReportItem(
      reportNo: (j['reportNo'] as num).toInt(),
      projectId: j['projectId'] ?? '',
      title: j['title'] ?? '',
      reportId: j['reportId'] ?? '',
      reportNickname: j['reportNickname'] ?? '',
      writerId: j['writerId'] ?? '',
      writerNickname: j['writerNickname'] ?? '',
      reportType: j['reportType'] ?? '',
      status: j['status'] ?? '',
    );
  }
}
