import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Виджет кнопок нижнего навигационного меню.
class AppBottomNavigationButton extends StatelessWidget {
  const AppBottomNavigationButton({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  /// Действие при нажатии на элемент.
  final VoidCallback onTap;

  /// Флаг, является ли элемент активным.
  final bool isSelected;

  /// Иконка элемента.
  final IconData icon;

  /// Название.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 58,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      icon,
                      size: 23,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(title),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
