class ProjectRequestItem {
  final String requestId;
  final String userSeq;
  final String nickname;
  final String? projectId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> images;
  final String requestType; // CREATE, UPDATE, DELETE 등
  final String requestStatus; // PENDING, APPROVED, REJECTED 등
  final String? adminSeq;

  ProjectRequestItem({
    required this.requestId,
    required this.userSeq,
    required this.nickname,
    this.projectId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.images,
    required this.requestType,
    required this.requestStatus,
    this.adminSeq,
  });

  factory ProjectRequestItem.fromJson(Map<String, dynamic> json) {
    return ProjectRequestItem(
      requestId: json['requestId'] as String,
      userSeq: json['userSeq'] as String,
      nickname: json['nickname'] as String? ?? '-',
      projectId: json['projectId'] as String?, // null 가능
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      images: (json['image'] as List<dynamic>).cast<String>(),
      requestType: json['requestType'] as String,
      requestStatus: json['requestStatus'] as String,
      adminSeq: json['adminSeq'] as String?, // null 가능
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userSeq': userSeq,
      'nickname': nickname,
      'projectId': projectId,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'image': images,
      'requestType': requestType,
      'requestStatus': requestStatus,
      'adminSeq': adminSeq,
    };
  }
}
