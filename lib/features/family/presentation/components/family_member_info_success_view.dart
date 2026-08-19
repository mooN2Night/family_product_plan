import 'package:family_product_plan/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/dialog/family_remove_member_dialog.dart';
import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../profile/domain/entity/profile_user_entity.dart';
import '../../../profile/presentation/components/widgets/profile_info.dart';
import '../../../profile/presentation/profile_routes.dart';
import '../../domain/entity/family_relation.dart';
import '../../domain/entity/family_role.dart';
import '../../domain/state/family_member_bloc/family_member_info_bloc.dart';
import '../../domain/state/family_remove_member_bloc/family_remove_member_bloc.dart';
import '../../utils/family_member_action.dart';

/// Экран с информацией об участнике семьи.
class FamilyMemberInfoSuccessView extends StatelessWidget {
  const FamilyMemberInfoSuccessView({
    required this.familyId,
    required this.user,
    required this.role,
    required this.relation,
    required this.canEditRelation,
    required this.isCurrentUser,
    super.key,
  });

  /// Идентификатор семьи.
  final String familyId;

  /// Информация о пользователе.
  final ProfileUserEntity user;

  /// Роль пользователя в семье.
  final FamilyRole role;

  /// Статус пользователя в семье.
  final FamilyRelation relation;

  /// Определяет, можно ли изменять статус участника.
  final bool canEditRelation;

  /// Указывает, является ли открытый профиль текущим пользователем.
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final formatedUserBirthday = AppUtils.formateDate(user.birthDate);

    return MultiBlocListener(
      listeners: [
        BlocListener<FamilyRemoveMemberBloc, FamilyRemoveMemberState>(
          listener: (context, state) {
            if (state is FamilyRemoveMemberErrorState) {
              AppSnackBar.showError(context, message: state.message);
            }

            if (state is FamilyRemoveMemberSuccessState) {
              switch (state.action) {
                case FamilyMemberAction.leave:
                  context.goNamed(ProfileRoutes.profileScreenName);

                case FamilyMemberAction.remove:
                  AppSnackBar.showSuccess(
                    context,
                    message: 'Участник удалён из семьи',
                  );

                  context.pop();
              }
            }
          },
        ),

        BlocListener<FamilyMemberInfoBloc, FamilyMemberInfoState>(
          listener: (context, state) {
            if (state is FamilyMemberInfoErrorState) {
              AppSnackBar.showError(context, message: state.message);
            }

            if (state is FamilyMemberInfoLoadedState) {
              AppSnackBar.showSuccess(
                context,
                message: 'Статус участника успешно изменен!',
              );
            }
          },
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          HBox(40),
          ProfileInfo(
            icon: Icons.badge_outlined,
            title: 'Фамилия:',
            description: user.lastName.isNotEmpty
                ? user.lastName
                : 'Не указано',
          ),
          HBox(5),
          ProfileInfo(
            icon: Icons.person_outline,
            title: 'Имя:',
            description: user.firstName.isNotEmpty
                ? user.firstName
                : 'Не указано',
          ),
          HBox(5),
          if (user.middleName.isNotEmpty) ...[
            ProfileInfo(
              icon: Icons.person_outline,
              title: 'Отчество:',
              description: user.middleName,
            ),
            HBox(5),
          ],
          ProfileInfo(
            icon: Icons.wc_outlined,
            title: 'Пол:',
            description: user.gender.title,
          ),
          if (formatedUserBirthday != null) ...[
            HBox(5),
            ProfileInfo(
              icon: Icons.cake_outlined,
              title: 'Дата рождения:',
              description: formatedUserBirthday,
            ),
          ],
          if (user.age != null) ...[
            HBox(5),
            ProfileInfo(
              icon: Icons.calendar_today_outlined,
              title: 'Возраст:',
              description: user.age!,
            ),
          ],
          HBox(5),
          ProfileInfo(
            icon: Icons.email_outlined,
            title: 'Почта:',
            description: user.email,
          ),
          HBox(5),
          _FamilyRelationField(
            relation: relation,
            canEdit: canEditRelation,
            onChanged: (relation) {
              context.read<FamilyMemberInfoBloc>().add(
                FamilyMemberInfoUpdateRelationEvent(
                  familyId: familyId,
                  userId: user.id,
                  relation: relation,
                ),
              );
            },
          ),
          const HBox(32),
          if (isCurrentUser || canEditRelation) ...[
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => showLeaveFamilyDialog(
                context,
                userId: user.id,
                familyId: familyId,
                canEdit: role == FamilyRole.owner,
                action: isCurrentUser
                    ? FamilyMemberAction.leave
                    : FamilyMemberAction.remove,
              ),
              icon: const Icon(Icons.logout),
              label: Text(
                isCurrentUser ? 'Выйти из семьи' : 'Удалить человека из семьи',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Поле отображения или изменения статуса участника в семье.
class _FamilyRelationField extends StatelessWidget {
  const _FamilyRelationField({
    required this.relation,
    required this.canEdit,
    required this.onChanged,
  });

  /// Текущий статус участника.
  final FamilyRelation relation;

  /// Определяет, доступно ли редактирование статуса.
  final bool canEdit;

  /// Вызывается при изменении статуса.
  final ValueChanged<FamilyRelation> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!canEdit) {
      return ProfileInfo(
        icon: Icons.family_restroom,
        title: 'Статус в семье:',
        description: relation.title,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Статус в семье'),
        const SizedBox(height: 8),
        DropdownButtonFormField<FamilyRelation>(
          initialValue: relation,
          items: FamilyRelation.values.map((relation) {
            return DropdownMenuItem(
              value: relation,
              child: Text(relation.title),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }
}
