import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Widget child;
  const StatCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}
