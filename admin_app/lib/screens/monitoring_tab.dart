import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/app_section_title.dart';
import '../widgets/stat_card.dart';

class MonitoringTab extends StatelessWidget {
  const MonitoringTab({super.key});

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
      ),
      backgroundColor: pageBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle('CPU Usage'),
            const SizedBox(height: 8),
            const StatCard(child: _ChartPlaceholder(title: 'CPU usage')),

            const SizedBox(height: 20),
            const AppSectionTitle('Events Disk Queue Size'),
            const SizedBox(height: 8),
            const StatCard(
              child: _ChartPlaceholder(title: 'Events disk queue size'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  final String title;
  const _ChartPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
            image: const DecorationImage(
              // 임시 그리드 느낌
              image: AssetImage('assets/sample.jpeg'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          alignment: Alignment.center,
          child: const Text('Chart Placeholder'),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _Legend(color: Colors.green, label: 'core 0'),
            SizedBox(width: 8),
            _Legend(color: Colors.orange, label: 'core 1'),
            SizedBox(width: 8),
            _Legend(color: Colors.blue, label: 'core 2'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
