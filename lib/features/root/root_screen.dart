import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/presentation/ui_kit/app_bottom_navigation_bar.dart';
import '../../app/presentation/ui_kit/app_bottom_navigation_button.dart';

/// Корневой экран приложения с навигационной структурой.
class RootScreen extends StatefulWidget {
  const RootScreen({required this.navigationShell, super.key});

  /// Текущая ветка навигации от GoRouter
  /// Содержит информацию о текущем состоянии навигации
  final StatefulNavigationShell navigationShell;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  /// Кнопки меню
  static const _buttonsIcon = [
    Icons.home_rounded,
    Icons.checklist_rounded,
    Icons.person_rounded,
  ];

  /// Заголовки меню
  static const _buttonsTitle = ['Главная', 'Задачи', 'Профиль'];

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        navigationButtons: List.generate(_buttonsIcon.length, (index) {
          return AppBottomNavigationButton(
            onTap: () => _onTap(index, context),
            isSelected: index == widget.navigationShell.currentIndex,
            icon: _buttonsIcon[index],
            title: _buttonsTitle[index],
          );
        }),
      ),
    );
  }

  /// Метод для обработки нажатия на кнопку меню
  void _onTap(int index, BuildContext context) {
    final isCurrentBrunch = index == widget.navigationShell.currentIndex;

    widget.navigationShell.goBranch(index, initialLocation: isCurrentBrunch);
  }
}
