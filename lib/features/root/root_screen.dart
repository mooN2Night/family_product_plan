import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/ui_kit/app_bottom_navigation_bar.dart';
import '../../app/ui_kit/app_bottom_navigation_button.dart';

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
  static const _buttonsIcon = [Icons.home, Icons.person];

  /// Заголовки меню
  static const _buttonsTitle = ['Главная', 'Профиль'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          viewPadding: MediaQuery.of(context).viewPadding.copyWith(
            bottom: MediaQuery.of(context).viewPadding.bottom / 2,
          ),
        ),
        child: AppBottomNavigationBar(
          navigationButtons: List.generate(2, (index) {
            return AppBottomNavigationButton(
              onTap: () => _onTap(index, context),
              isSelected: index == widget.navigationShell.currentIndex,
              icon: _buttonsIcon[index],
              title: _buttonsTitle[index],
            );
          }),
        ),
      ),
    );
  }

  /// Метод для обработки нажатия на кнопку меню
  void _onTap(int index, BuildContext context) {
    final isCurrentBrunch = index == widget.navigationShell.currentIndex;

    widget.navigationShell.goBranch(index, initialLocation: isCurrentBrunch);
  }
}
