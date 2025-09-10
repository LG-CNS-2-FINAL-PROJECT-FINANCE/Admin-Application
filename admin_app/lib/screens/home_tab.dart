import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/app_section_title.dart';
import '../widgets/kpi_widgets.dart';
import '../data/home_summary.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final MetricsApi api;
  late Future<HomeSummary> _future;

  @override
  void initState() {
    super.initState();
    // ↓ 네 MetricsApi 구현에 맞게 하나만 선택
    // 1) Uri.parse 방식이면:
    api = MetricsApi('http://43.203.233.216:9090');

    // 2) Uri.http(hostWithPort, ...) 방식이면:
    // api = MetricsApi('13.124.228.130:9090');

    _future = api.fetchSummary();
  }

  void _reload() {
    setState(() {
      _future = api.fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,

        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: FutureBuilder<HomeSummary>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _ErrorView(onRetry: _reload, message: '${snap.error}');
          }
          final s = snap.data;
          if (!snap.hasData || s == null) {
            return _ErrorView(onRetry: _reload, message: 'No data');
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSectionTitle('System Status'),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, cs) {
                    const gap = 12.0;
                    final w = (cs.maxWidth - gap) / 2;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        SizedBox(
                          width: w,
                          child: KpiTile(
                            label: 'Pods',
                            value: s.pods.toStringAsFixed(0), // 정수 개수
                            icon: Icons.view_module,
                          ),
                        ),
                        SizedBox(
                          width: w,
                          child: KpiTile(
                            label: 'Pods PCT',
                            value: '${s.podRequestPct.toStringAsFixed(1)}%',
                            statusColor: s.podRequestPct < 70
                                ? Colors.green
                                : (s.podRequestPct < 85
                                      ? Colors.orange
                                      : Colors.red),
                            icon: Icons.view_module,
                          ),
                        ),
                        SizedBox(
                          width: w,
                          child: KpiTile(
                            label: 'RPS',
                            value: s.rps.toStringAsFixed(1),
                            icon: Icons.trending_up,
                          ),
                        ),
                        SizedBox(
                          width: w,
                          child: KpiTile(
                            label: 'CPU',
                            value: '${s.cpuPct.toStringAsFixed(1)}%',
                            statusColor: s.cpuPct < 70
                                ? Colors.green
                                : (s.cpuPct < 85 ? Colors.orange : Colors.red),
                            icon: Icons.memory,
                          ),
                        ),
                        SizedBox(
                          width: w,
                          child: KpiTile(
                            label: 'Memory',
                            value: '${s.memPct.toStringAsFixed(1)}%',
                            statusColor: s.memPct < 70
                                ? Colors.green
                                : (s.memPct < 85 ? Colors.orange : Colors.red),
                            icon: Icons.storage,
                          ),
                        ),
                        SizedBox(
                          width: w,
                          child: KpiTile(
                            label: 'Nodes',
                            value: s.nodeCount.toStringAsFixed(0), // 정수
                            icon: Icons.dns,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;
  const _ErrorView({required this.onRetry, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 40, color: Colors.black45),
            const SizedBox(height: 10),
            const Text('요약 정보를 불러오지 못했어요.'),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
