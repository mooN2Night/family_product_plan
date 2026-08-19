import 'dart:ui';

abstract final class AppColors {
  // Primary
  static const primary = Color(0xFF7048C4);
  static const primaryLight = Color(0xFF9B7BE3);
  static const primarySoft = Color(0xFFE8E0F8);

  // Background
  static const background = Color(0xFFF8F8F8);

  // Surfaces
  static const surface = Color(0xFFFFFFFF);
  static const textDisabled = Color(0xFFB0ACB3);
  static const border = Color(0xFFE8E5EA);

  // Text
  static const textPrimary = Color(0xFF25232A);
  static const textSecondary = Color(0xFF6F6A78);
  static const textInactive = Color(0xFF9B98A2);

  // Other
  static const divider = Color(0xFFE8E5ED);

  // Bottom navigation
  static const bottomBar = Color(0xFFF1ECFA);
  static const bottomBarActive = Color(0xFFE3D8F8);

  /// Базовый цвет skeleton-блоков.
  static const skeleton = Color(0xFFEAE7F1);

  /// Цвет светлой shimmer-анимации.
  static const skeletonHighlight = Color(0xFFF8F6FC);
}
