import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/profile/domain/entity/profile_user_entity.dart';
import '../../../features/profile/presentation/profile_routes.dart';

Future<void> openEnterFamilyErrorDialog(
  BuildContext context, {
  required String title,
  required String firstName,
  required String lastName,
  required String middleName,
  required DateTime? birthDate,
  required Gender gender,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Для $title нужно указать эти поля:'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              if (firstName.isEmpty) Text('- Имя'),
              if (lastName.isEmpty) Text('- Фамилия'),
              if (middleName.isEmpty) Text('- Отчество'),
              if (birthDate == null) Text('- Дата рождения'),
              if (gender == Gender.unspecified) Text('- Пол'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context
              ..pop()
              ..pushNamed(ProfileRoutes.profileEditorScreenName),
            child: const Text(
              'Перейти в настройки',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            child: const Text('Отмена', style: TextStyle(color: Colors.red)),
            onPressed: () => context.pop(),
          ),
        ],
      );
    },
  );
}
