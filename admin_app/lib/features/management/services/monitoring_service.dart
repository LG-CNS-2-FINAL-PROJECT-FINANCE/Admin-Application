// lib/features/management/services/monitoring_service.dart
import 'dart:convert';
import 'package:admin_app/core/config/app_config.dart';
import 'package:admin_app/core/services/api_service.dart';
import 'package:admin_app/models/report.dart';

class MonitoringService {
  final ApiService _api = ApiService(AppConfig.baseUrl);

  Future<List<ReportItem>> fetchReports() async {
    final res = await _api.get('/api/monitoring/report/admin/list');
    if (res.statusCode != 200) {
      throw Exception('보고서 목록 불러오기 실패 (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);
    final List list = (decoded is Map && decoded['data'] is List)
        ? decoded['data'] as List
        : (decoded as List);

    return list
        .map((e) => ReportItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
