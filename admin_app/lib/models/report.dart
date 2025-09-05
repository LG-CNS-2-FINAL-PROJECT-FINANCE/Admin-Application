class Report {
  final String projectName;
  final String reporter;
  final String owner;
  final String status;
  final String kind;
  final String description;
  final String imageAsset; // 프로젝트 이미지를 에셋으로 가정

  const Report({
    required this.projectName,
    required this.reporter,
    required this.owner,
    required this.status,
    required this.kind,
    required this.description,
    required this.imageAsset,
  });
}
