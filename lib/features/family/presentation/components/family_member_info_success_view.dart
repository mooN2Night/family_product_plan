import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../../profile/domain/entity/profile_user_entity.dart';
import '../../../profile/presentation/components/profile_info.dart';
import '../../domain/entity/family_relation.dart';
import '../../domain/entity/family_role.dart';
import '../../domain/state/family_member/family_member_info_bloc.dart';

class FamilyMemberInfoSuccessView extends StatelessWidget {
  const FamilyMemberInfoSuccessView({
    required this.familyId,
    required this.user,
    required this.role,
    required this.relation,
    required this.canEditRelation,
    super.key,
  });

  final String familyId;
  final ProfileUserEntity user;
  final FamilyRole role;
  final FamilyRelation relation;
  final bool canEditRelation;

  @override
  Widget build(BuildContext context) {
    // TODO: добавить BlocListener, который будет показывать уведомления, что статус успешно сохранен
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        HBox(40),
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
        HBox(5),
        FamilyRelationField(
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
      ],
    );
  }
}

class FamilyRelationField extends StatelessWidget {
  const FamilyRelationField({
    super.key,
    required this.relation,
    required this.canEdit,
    required this.onChanged,
  });

  final FamilyRelation relation;
  final bool canEdit;
  final ValueChanged<FamilyRelation> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!canEdit) {
      return ProfileInfo(title: 'Статус в семье:', description: relation.title);
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
