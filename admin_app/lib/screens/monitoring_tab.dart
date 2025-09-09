import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/colors.dart';

class MonitoringTab extends StatefulWidget {
  const MonitoringTab({super.key});

  @override
  State<MonitoringTab> createState() => _MonitoringTabState();
}

class _MonitoringTabState extends State<MonitoringTab> {
  late final WebViewController _controller;
  bool _loading = true;

  // Grafana 대시보드 URL (원한다면 특정 대시보드/kiosk 모드로)
  final Uri grafanaUrl = Uri.parse(
    // 예) 전체 목록: /dashboards
    // 특정 대시보드(추천): /d/<uid>/<slug>?orgId=1&kiosk&refresh=30s&theme=light
    'http://13.124.228.130:3000/dashboards',
  );

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(pageBg)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('WebView 오류: ${e.errorCode}')),
            );
          },
        ),
      )
      ..loadRequest(grafanaUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Monitoring',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
