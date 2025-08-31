import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/app_section_title.dart';
import '../widgets/stat_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
      ),
      backgroundColor: pageBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle('System Status'),
            const SizedBox(height: 8),

            // 카드 1: 좌우 두 블록 사이 세로 구분선
            StatCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: _GaugePlaceholder(
                      title: 'DB indexing speed',
                      valueText: '197 EPS',
                      status: 'OK',
                    ),
                  ),
                  const SizedBox(width: 8),
                  // VerticalDivider는 레이아웃 제약에 따라 높이가 0이 될 수 있어 Container로 대체
                  Container(width: 1, height: 88, color: Colors.black12),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: _GaugePlaceholder(
                      title: 'Sys Load (5m avg)',
                      valueText: '16.3%',
                      status: '2.8 days',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const AppSectionTitle('System Reports'),
            const SizedBox(height: 8),
            const StatCard(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('현재 시스템은 정상적으로 동작하고 있습니다.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePlaceholder extends StatelessWidget {
  final String title;
  final String valueText;
  final String status;
  const _GaugePlaceholder({
    required this.title,
    required this.valueText,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Colors.green.shade400 같은 shade 접근은 const가 아니므로, 위젯 자체는 const 생성자여도 OK
    final ringColor = Colors.green.shade400;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 6),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(status, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
