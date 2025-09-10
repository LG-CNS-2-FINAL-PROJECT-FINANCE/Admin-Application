// data/home_summary.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class HomeSummary {
  final DateTime ts;
  final double pods,
      cpuPct,
      memPct,
      rps,
      nodeCount,
      podRequestPct; // cpuPct = CPU Requested %
  HomeSummary({
    required this.ts,
    required this.pods,
    required this.cpuPct, // ← 여기에 Requested%를 넣을 거야
    required this.memPct,
    required this.rps,
    required this.nodeCount,
    required this.podRequestPct,
  });
}

class MetricsApi {
  final String hostWithPort; // '13.124.228.130:9090'
  final String? bearer;
  late final IOClient _client;

  MetricsApi(String base, {this.bearer})
    : hostWithPort = base.replaceFirst(RegExp(r'^https?://'), '') {
    final hc = HttpClient()
      ..connectionTimeout = const Duration(seconds: 6)
      ..idleTimeout = const Duration(seconds: 15);
    _client = IOClient(hc);
  }

  Future<HomeSummary> fetchSummary() async {
    // 필요 시 라벨 필터 추가: up{job="myapp"}, http_requests_total{job="myapp"}
    final pods = await _instant(
      'sum(kube_pod_status_phase{phase=~"Running|Pending"})',
    );
    final cpu = await _instant(
      '('
      'sum(kube_pod_container_resource_requests{resource="cpu",unit="core"})'
      ' / '
      'sum(kube_node_status_allocatable{resource="cpu",unit="core"})'
      ') * 100',
    );
    final mem = await _instant(
      '('
      'sum(kube_pod_container_resource_requests{resource="memory",unit="byte"})'
      ' / '
      'sum(kube_node_status_allocatable{resource="memory",unit="byte"})'
      ') * 100',
    );
    final rps = await _instant('sum(rate(http_requests_total[1m]))');
    final nodes = await _instant('count(kube_node_info)');
    final podRequestedPct = await _instant(
      '('
      'sum(kube_pod_status_phase{phase=~"Running|Pending"} == 1)'
      ' / '
      'sum(kube_node_status_allocatable{resource="pods"})'
      ') * 100',
    );

    return HomeSummary(
      ts: DateTime.now(),
      pods: pods,
      cpuPct: cpu,
      memPct: mem,
      rps: rps,
      nodeCount: nodes,
      podRequestPct: podRequestedPct,
    );
  }

  Future<double> _instant(String promql) async {
    final uri = Uri.http(
      hostWithPort, // '13.124.228.130:9090'
      '/api/v1/query',
      {'query': promql},
    );
    // ignore: avoid_print
    print('GET $uri');

    try {
      final resp = await _client
          .get(
            uri,
            headers: {if (bearer != null) 'Authorization': 'Bearer $bearer'},
          )
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode != 200) {
        throw Exception(
          'HTTP ${resp.statusCode}: ${resp.reasonPhrase}\n${resp.body}',
        );
      }

      final j = jsonDecode(resp.body);
      if (j is! Map || j['status'] != 'success') {
        throw Exception('Prometheus error: ${resp.body}');
      }

      final result = (j['data']?['result'] as List?) ?? const [];
      if (result.isEmpty) return 0.0;
      final v = result.first['value']?[1]?.toString() ?? '0';
      return double.tryParse(v) ?? 0.0;
    } on TimeoutException catch (e) {
      throw Exception('Timeout: $e\nURL: $uri');
    } on SocketException catch (e) {
      throw Exception('SocketException: $e\nURL: $uri');
    }
  }
}
