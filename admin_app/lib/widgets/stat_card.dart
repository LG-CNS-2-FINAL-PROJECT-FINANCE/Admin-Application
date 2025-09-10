// widgets/stat_card.dart
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap; // 👈 onTap 파라미터 추가

  const StatCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          // 👈 최소 사이즈 보장
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            minHeight: 48,
          ),
          child: Padding(padding: const EdgeInsets.all(12), child: child),
        ),
      ),
    );
  }
}
