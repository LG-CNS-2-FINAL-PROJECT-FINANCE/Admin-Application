import 'dart:convert';
import 'package:admin_app/core/services/api_service.dart';
import 'package:admin_app/core/config/app_config.dart';
import 'package:admin_app/models/project.dart';
import 'package:admin_app/models/project_request.dart';

class ProjectService {
  ProjectService() : _api = ApiService(AppConfig.baseUrl);
  final ApiService _api;

  Future<List<ProjectRequestItem>> fetchProjectsRequest() async {
    // TODO: 실제 엔드포인트로 교체
    final res = await _api.get('/api/product/request/admin');

    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body) as List<dynamic>;
      return list
          .map((e) => ProjectRequestItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('프로젝트 요청 목록 불러오기 실패: ${res.statusCode}');
  }

  Future<List<ProjectItem>> fetchProjects() async {
    // TODO: 실제 엔드포인트로 교체
    final res = await _api.get('/api/product/admin');

    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body) as List<dynamic>;
      return list
          .map((e) => ProjectItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('프로젝트 요청 목록 불러오기 실패: ${res.statusCode}');
  }

  Future<bool> approveProjectRequest({required String requestId}) async {
    final res = await _api.post('/api/product/request/approve', {
      'requestId': requestId,
    });

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('승인 실패 (${res.statusCode})');
    }
  }

  Future<bool> rejectProjectRequest({required String requestId}) async {
    final res = await _api.post('/api/product/request/reject', {
      'requestId': requestId,
    });

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('거절 실패 (${res.statusCode})');
    }
  }
}
