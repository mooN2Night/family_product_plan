import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:family_product_plan/features/profile/presentation/components/profile_info.dart';
import 'package:family_product_plan/features/profile/presentation/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../../auth/domain/state/auth_bloc.dart';
import '../../../family/presentation/family_routes.dart';

/// Виджет отображения успешно загруженных данных пользователя.
class ProfileSuccessView extends StatelessWidget {
  const ProfileSuccessView({required this.user, super.key});

  /// Пользователь.
  final ProfileUserEntity user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        HBox(40),
        // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 40),
        //   child: AspectRatio(
        //     aspectRatio: 1,
        //     child: Container(
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.greenAccent,
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(40),
        //         child: Image.asset(
        //           'assets/images/person_no_image.png',
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // HBox(20),
        ProfileInfo(
          title: 'Фамилия:',
          description: user.lastName.isNotEmpty ? user.lastName : 'Не указано',
        ),
        HBox(5),
        ProfileInfo(
          title: 'Имя:',
          description: user.firstName.isNotEmpty
              ? user.firstName
              : 'Не указано',
        ),
        HBox(5),
        if (user.middleName.isNotEmpty) ...[
          ProfileInfo(title: 'Отчество:', description: user.middleName),
          HBox(5),
        ],
        ProfileInfo(title: 'Пол:', description: user.gender.title),
        if (user.formatedBirthDate != null) ...[
          HBox(5),
          ProfileInfo(
            title: 'Дата рождения:',
            description: user.formatedBirthDate!,
          ),
        ],
        if (user.age != null) ...[
          HBox(5),
          ProfileInfo(title: 'Возраст:', description: user.age!),
        ],
        HBox(5),
        ProfileInfo(title: 'Почта:', description: user.email),
        if (user.familyId == null) ...[
          HBox(40),
          Text('У вас пока нет семьи'),
          HBox(5),
          FilledButton(
            onPressed:
                user.firstName.isEmpty ||
                    user.lastName.isEmpty ||
                    user.birthDate == null ||
                    user.gender == Gender.unspecified
                ? () => _openEnterFamilyErrorDialog(
                    context,
                    title: 'создания семьи',
                    firstName: user.firstName,
                    lastName: user.lastName,
                    middleName: user.middleName,
                    birthDate: user.birthDate,
                    gender: user.gender,
                  )
                : () => context.pushNamed(FamilyRoutes.familyCreateScreenName),
            child: Text('Создать семью'),
          ),
          HBox(5),
          OutlinedButton(
            onPressed:
                user.firstName.isEmpty ||
                    user.lastName.isEmpty ||
                    user.birthDate == null ||
                    user.gender == Gender.unspecified
                ? () => _openEnterFamilyErrorDialog(
                    context,
                    title: 'присоединении к семье',
                    firstName: user.firstName,
                    lastName: user.lastName,
                    middleName: user.middleName,
                    birthDate: user.birthDate,
                    gender: user.gender,
                  )
                : () => context.pushNamed(FamilyRoutes.familyJoinScreenName),
            child: Text('Присоединиться к семье'),
          ),
        ] else ...[
          HBox(40),
          FilledButton(
            onPressed: () => context.pushNamed(
              FamilyRoutes.familyInfoScreenName,
              pathParameters: {'familyId': user.familyId!},
            ),
            child: Text('Посмотреть свою семью'),
          ),
        ],
        HBox(40),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignOutEvent()),
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              minimumSize: const WidgetStatePropertyAll(Size.zero),
            ),
            child: Text('Выйти из аккаунта'),
          ),
        ),
        HBox(20),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextButton(
            // TODO: Сделать модалку с проверкой пароля и удалить после этого аккаунт
            onPressed: () => context.read<AuthBloc>().add(
              const AuthDeleteAccountEvent(password: '123123'),
            ),
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              minimumSize: const WidgetStatePropertyAll(Size.zero),
            ),
            child: Text(
              'Удалить аккаунта',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _openEnterFamilyErrorDialog(
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
