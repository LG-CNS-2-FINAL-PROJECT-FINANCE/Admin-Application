import 'package:flutter/material.dart';

Color statusByAvail(double v) =>
    v >= 99.9 ? Colors.green : (v >= 99.0 ? Colors.orange : Colors.red);

Color statusByError(double v) =>
    v < 1.0 ? Colors.green : (v < 5.0 ? Colors.orange : Colors.red);

class KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? statusColor;
  final IconData? icon;

  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    this.statusColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          if (icon != null)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: (statusColor ?? c.primaryColor).withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: statusColor ?? c.primaryColor),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (statusColor != null)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class DuoGauge extends StatelessWidget {
  final double cpuPct; // 0~100
  final double memPct; // 0~100
  const DuoGauge({super.key, required this.cpuPct, required this.memPct});

  @override
  Widget build(BuildContext context) {
    Widget gauge(String label, double pct, Color color) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12, width: 8),
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Color colorOf(double p) =>
        p < 70 ? Colors.green : (p < 85 ? Colors.orange : Colors.red);

    return Row(
      children: [
        gauge('CPU', cpuPct, colorOf(cpuPct)),
        const SizedBox(width: 12),
        gauge('Memory', memPct, colorOf(memPct)),
      ],
    );
  }
}

class AlertBadges extends StatelessWidget {
  final int critical;
  final int warning;
  const AlertBadges({super.key, required this.critical, required this.warning});

  @override
  Widget build(BuildContext context) {
    Widget badge(Color color, String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );

    return Row(
      children: [
        badge(Colors.red, 'Critical $critical'),
        const SizedBox(width: 8),
        badge(Colors.orange, 'Warn $warning'),
      ],
    );
  }
}
