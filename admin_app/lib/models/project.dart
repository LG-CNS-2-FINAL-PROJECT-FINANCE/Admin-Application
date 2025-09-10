class ProjectItem {
  final String projectId;
  final String userSeq;
  final String nickname;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int deadline;
  final int amount;
  final int percent;
  final List<String> images;
  final int viewCount;
  final String projectStatus;
  final String projectVisibility;
  final int? tradePrice;

  ProjectItem({
    required this.projectId,
    required this.userSeq,
    required this.nickname,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.deadline,
    required this.amount,
    required this.percent,
    required this.images,
    required this.viewCount,
    required this.projectStatus,
    required this.projectVisibility,
    this.tradePrice,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      projectId: json['projectId'] as String,
      userSeq: json['userSeq'] as String,
      nickname: json['nickname'] as String? ?? '-',
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      deadline: (json['deadline'] as num).toInt(), // 🔑 num → int
      amount: (json['amount'] as num).toInt(), // 🔑 num → int
      percent: (json['percent'] as num).toInt(), // 🔑 num → int
      images: (json['image'] as List<dynamic>).cast<String>(),
      viewCount: (json['viewCount'] as num).toInt(), // 🔑 num → int
      projectStatus: json['projectStatus'] as String,
      projectVisibility: json['projectVisibility'] as String,
      tradePrice: json['tradePrice'] == null
          ? null
          : (json['tradePrice'] as num).toInt(),
    );
  }
}
