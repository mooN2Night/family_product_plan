import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Типы пользовательского AppBar, используемые в приложении.
enum CustomAppBarType {
  /// AppBar основных экранов приложения.
  main,

  /// AppBar вторичных экранов.
  secondary,
}

/// Пользовательская реализация AppBar.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Базовый конструктор пользовательского AppBar.
  const CustomAppBar._({
    required this.type,
    required this.title,
    this.actions = const [],
    this.bottom,
  });

  /// Создает AppBar для главного экрана.
  factory CustomAppBar.main({
    required String title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return CustomAppBar._(
      type: CustomAppBarType.main,
      title: title,
      bottom: bottom,
      actions: actions,
    );
  }

  /// Создает AppBar для экрана профиля.
  factory CustomAppBar.secondary({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar._(
      type: CustomAppBarType.secondary,
      title: title,
      actions: actions,
    );
  }

  /// Виджет, отображаемый в нижней части AppBar.
  final PreferredSizeWidget? bottom;

  /// Набор действий, отображаемых справа в AppBar.
  final List<Widget>? actions;

  /// Тип текущей конфигурации AppBar.
  final CustomAppBarType type;

  /// Заголовок AppBar.
  final String title;

  @override
  Widget build(BuildContext context) {
    final isMain = type == CustomAppBarType.main;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.7),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
          child: AppBar(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: !isMain,
            foregroundColor: AppColors.textPrimary,
            actions: _buildActions(context),
            bottom: bottom,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return actions
            ?.map(
              (action) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: action,
              ),
            )
            .toList() ??
        [];
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0),
    );
  }
}
