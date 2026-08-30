import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_field_group.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_family_card.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_header.dart';
import 'package:family_product_plan/features/profile/presentation/components/widgets/profile_no_family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/presentation/dialog/profile_delete_account_dialog.dart';
import '../../../../../app/presentation/dialog/profile_enter_family_error_dialog.dart';
import '../../../../../app/presentation/ui_kit/app_actions_tile.dart';
import '../../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../../app/utils/app_utils.dart';
import '../../../../auth/domain/state/auth_bloc.dart';
import '../../../../family/domain/state/family_fetch/family_fetch_bloc.dart';
import '../../../../family/presentation/family_routes.dart';

/// Виджет отображения успешно загруженных данных пользователя.
class ProfileSuccessView extends StatelessWidget {
  const ProfileSuccessView({required this.user, super.key});

  /// Пользователь.
  final ProfileUserEntity user;

  @override
  Widget build(BuildContext context) {
    final formatedUserBirthday = AppUtils.formateDate(user.birthDate);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 140),
      children: [
        ProfileHeader(
          initials: user.getInitials,
          name: user.fullName.isNotEmpty ? user.fullName : 'Пользователь',
          email: user.email,
        ),
        HBox(16),
        AppFieldGroup(
          children: [
            if (user.lastName.isNotEmpty) ...[
              AppActionTile(
                icon: Icons.badge_outlined,
                label: 'Фамилия',
                value: user.lastName,
              ),
              AppFieldDivider(),
            ],

            AppActionTile(
              icon: Icons.person_outline,
              label: 'Имя',
              value: user.firstName.isNotEmpty ? user.firstName : 'Не указано',
            ),
            AppFieldDivider(),

            if (user.middleName.isNotEmpty) ...[
              AppActionTile(
                icon: Icons.person_outline,
                label: 'Отчество',
                value: user.middleName,
              ),
              AppFieldDivider(),
            ],

            AppActionTile(
              icon: Icons.wc_outlined,
              label: 'Пол',
              value: user.gender.title,
            ),
            AppFieldDivider(),

            if (formatedUserBirthday != null) ...[
              AppActionTile(
                icon: Icons.cake_outlined,
                label: 'Дата рождения',
                value: formatedUserBirthday,
              ),
              AppFieldDivider(),
            ],

            if (user.age != null) ...[
              AppActionTile(
                icon: Icons.calendar_today_outlined,
                label: 'Возраст',
                value: user.age!,
              ),
              AppFieldDivider(),
            ],

            AppActionTile(
              icon: Icons.email_outlined,
              label: 'Почта',
              value: user.email,
            ),
          ],
        ),
        HBox(16),
        if (user.familyId != null)
          BlocProvider(
            create: (context) => FamilyFetchBloc(
              familyRepository: context.di.repositories.familyRepository,
            )..add(FamilyFetchRequestedEvent(familyId: user.familyId!)),
            child: ProfileFamilyCard(
              onTap: () => context.pushNamed(
                FamilyRoutes.familyInfoScreenName,
                pathParameters: {'familyId': user.familyId!},
              ),
              familyId: user.familyId!,
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
        HBox(16),
        AppFieldGroup(
          children: [
            AppActionTile(
              icon: Icons.logout_outlined,
              value: 'Выйти из аккаунта',
              trailingIcon: Icons.chevron_right_rounded,
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthSignOutEvent()),
            ),
            AppFieldDivider(),
            AppActionTile(
              icon: Icons.delete_outline,
              value: 'Удалить аккаунт',
              trailingIcon: Icons.chevron_right_rounded,
              onTap: () => showDeleteAccountDialog(context),
            ),
          ],
        ),
      ],
    );
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
      openEnterFamilyErrorDialog(
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
