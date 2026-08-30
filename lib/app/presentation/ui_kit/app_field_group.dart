import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Карточка-контейнер для группы полей: [AppTextField], [AppDropdownField],
/// [AppActionTile] и т.п. Обычно несколько таких карточек идут друг за другом
/// на экранах создания/редактирования.
class AppFieldGroup extends StatelessWidget {
  const AppFieldGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

/// Разделитель между полями внутри [AppFieldGroup] со сдвигом под иконку.
class AppFieldDivider extends StatelessWidget {
  const AppFieldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Divider(height: 1),
    );
  }
}
