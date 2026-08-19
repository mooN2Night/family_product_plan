import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_account_actions.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_family_card.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_header.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_no_family_card.dart';
import 'package:family_product_plan/features/profile/presentation/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../../app/utils/app_utils.dart';
import '../../../../auth/domain/state/auth_bloc.dart';
import '../../../../family/presentation/family_routes.dart';
import '../widgets/profile_info.dart';
import '../widgets/profile_info_card.dart';

/// Виджет отображения успешно загруженных данных пользователя.
class ProfileSuccessView extends StatelessWidget {
  const ProfileSuccessView({required this.user, super.key});

  /// Пользователь.
  final ProfileUserEntity user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatedUserBirthday = AppUtils.formateDate(user.birthDate);
    final initials = _getInitials(user);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 140),
      children: [
        ProfileHeader(
          initials: initials,
          name: user.fullName.isNotEmpty ? user.fullName : 'Пользователь',
          email: user.email,
        ),
        HBox(28),
        ProfileInfoCard(
          children: [
            ProfileInfo(
              icon: Icons.person_outline,
              title: 'Имя',
              description: user.firstName.isNotEmpty
                  ? user.firstName
                  : 'Не указано',
            ),

            if (user.lastName.isNotEmpty)
              ProfileInfo(
                icon: Icons.badge_outlined,
                title: 'Фамилия',
                description: user.lastName,
              ),

            if (user.middleName.isNotEmpty)
              ProfileInfo(
                icon: Icons.person_outline,
                title: 'Отчество',
                description: user.middleName,
              ),

            ProfileInfo(
              icon: Icons.wc_outlined,
              title: 'Пол',
              description: user.gender.title,
            ),

            if (formatedUserBirthday != null)
              ProfileInfo(
                icon: Icons.cake_outlined,
                title: 'Дата рождения',
                description: formatedUserBirthday,
              ),

            if (user.age != null)
              ProfileInfo(
                icon: Icons.calendar_today_outlined,
                title: 'Возраст',
                description: user.age!,
              ),

            ProfileInfo(
              icon: Icons.email_outlined,
              title: 'Почта',
              description: user.email,
              isLast: true,
            ),
          ],
        ),
        HBox(28),
        Text(
          'Семья',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        HBox(12),
        if (user.familyId != null)
          ProfileFamilyCard(
            onTap: () => context.pushNamed(
              FamilyRoutes.familyInfoScreenName,
              pathParameters: {'familyId': user.familyId!},
            ),
          )
        else
          ProfileNoFamilyCard(
            onCreateFamily: () {
              _handleFamilyAction(
                context,
                user: user,
                title: 'создания семьи',
                action: () =>
                    context.pushNamed(FamilyRoutes.familyCreateScreenName),
              );
            },
            onJoinFamily: () {
              _handleFamilyAction(
                context,
                user: user,
                title: 'присоединения к семье',
                action: () =>
                    context.pushNamed(FamilyRoutes.familyJoinScreenName),
              );
            },
          ),
        HBox(28),
        Text(
          'Аккаунт',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        HBox(12),
        ProfileAccountActions(
          onLogout: () {
            context.read<AuthBloc>().add(const AuthSignOutEvent());
          },
          onDelete: () {
            _showDeleteAccountDialog(context);
          },
        ),
      ],
    );
  }

  String _getInitials(ProfileUserEntity user) {
    final first = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final last = user.lastName.isNotEmpty ? user.lastName[0] : '';
    final initials = '$first$last';

    return initials.isNotEmpty ? initials.toUpperCase() : '?';
  }

  void _handleFamilyAction(
    BuildContext context, {
    required ProfileUserEntity user,
    required String title,
    required VoidCallback action,
  }) {
    if (user.firstName.isEmpty ||
        user.lastName.isEmpty ||
        user.birthDate == null ||
        user.gender == Gender.unspecified) {
      _openEnterFamilyErrorDialog(
        context,
        title: title,
        firstName: user.firstName,
        lastName: user.lastName,
        middleName: user.middleName,
        birthDate: user.birthDate,
        gender: user.gender,
      );

      return;
    }

    action();
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

Future<void> _showDeleteAccountDialog(BuildContext context) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Удалить аккаунт?'),
        content: const Text(
          'Все данные аккаунта будут удалены. '
          'Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => context.pop(true),
            child: const Text('Удалить'),
          ),
        ],
      );
    },
  );

  if (shouldDelete != true || !context.mounted) {
    return;
  }

  // Здесь позже сделаем нормальный сценарий:
  // 1. запросить пароль;
  // 2. reauthenticate Firebase;
  // 3. удалить аккаунт.
}
