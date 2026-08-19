import 'package:family_product_plan/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

/// Виджет скелетона для отображения во время загрузке данных.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.animationColor,
    this.borderRadius = 12,
  });

  /// Ширина блока. По умолчанию занимает весь доступный размер.
  final double? width;

  /// Высота блока. По умолчанию занимает весь доступный размер.
  final double? height;

  /// Радиус закругления углов.
  final double borderRadius;

  /// Цвет светлой накладки shimmer-анимации.
  final Color? animationColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: animationColor ?? AppColors.skeletonHighlight,
      direction: const ShimmerDirection.fromLeftToRight(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.skeleton,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
