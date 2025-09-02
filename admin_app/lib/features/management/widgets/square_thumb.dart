import 'package:flutter/material.dart';

class SquareThumb extends StatelessWidget {
  final double size;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final ImageProvider? image; // 있으면 이미지 보여줌
  final Widget? fallback; // 이미지 없거나 로드 실패 시 대체 위젯

  const SquareThumb({
    super.key,
    this.size = 56,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.backgroundColor = const Color(0xFF0E2C4A),
    this.image,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(width: size, height: size, color: backgroundColor);

    if (image == null) {
      // 이미지가 없으면 단색 박스 또는 fallback 사용
      return ClipRRect(borderRadius: borderRadius, child: fallback ?? box);
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image(
        image: image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback ?? box,
      ),
    );
  }
}
