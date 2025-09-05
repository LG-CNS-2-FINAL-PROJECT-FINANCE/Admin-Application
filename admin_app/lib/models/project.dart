class ProjectFile {
  final String name;
  final String? url; // 다운로드 주소가 있다면 사용
  const ProjectFile({required this.name, this.url});
}

class Project {
  final String name; // 프로젝트 이름
  final DateTime startAt; // 시작일
  final DateTime endAt; // 종료일
  final String status; // 예: APPROVED
  final String kind; // 예: CREATE
  final String summary; // 프로젝트 설명
  final String projectId; // 프로젝트 ID
  final String userId; // 작성자 ID
  final int goal; // 목표 금액
  final int minimum; // 최소 금액
  final String? imageAsset; // 커버 이미지 에셋 경로 (없으면 null)
  final List<ProjectFile> files;

  const Project({
    required this.name,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.kind,
    required this.summary,
    required this.projectId,
    required this.userId,
    required this.goal,
    required this.minimum,
    this.imageAsset,
    required this.files,
  });
}
