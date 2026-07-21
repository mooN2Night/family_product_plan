import 'package:flutter/material.dart';

import '../../../../app/ui_kit/app_box.dart';

/// Виджет отображения информации пользователя в профиле
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    required this.title,
    required this.description,
    super.key,
  });

  /// Заголовок
  final String title;

  /// Описание
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        WBox(5),
        Text(
          description,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
