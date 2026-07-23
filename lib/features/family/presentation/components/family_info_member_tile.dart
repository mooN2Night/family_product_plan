import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/features/family/presentation/family_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/utils/family_remove_member_dialog.dart';
import '../../domain/entity/family_member_info_entity.dart';
import '../../domain/entity/family_role.dart';
import '../../utils/family_member_action.dart';

/// Виджет отображения карточки участника семьи.
class FamilyInfoMemberTile extends StatelessWidget {
  const FamilyInfoMemberTile({
    required this.member,
    required this.familyId,
    super.key,
  });

  /// Информация об участнике.
  final FamilyMemberInfoEntity member;

  /// Уникальный идентификатор семьи.
  final String familyId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: member.isCurrentUser
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        onTap: () => context.pushNamed(
          FamilyRoutes.familyMemberInfoScreenName,
          pathParameters: {'userId': member.userId, 'familyId': familyId},
          queryParameters: {
            'role': member.role.toString(),
            'relation': member.relation.toString(),
            'canEditRelation': member.canEditRelation.toString(),
            'isCurrentUser': member.isCurrentUser.toString(),
          },
        ),
        title: Text(member.fullName),
        subtitle: Text(member.relation.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (member.role == FamilyRole.owner) Icon(Icons.star, size: 20),
            if (member.canEditRelation) ...[
              WBox(10),
              GestureDetector(
                onTap: () => showLeaveFamilyDialog(
                  context,
                  action: member.isCurrentUser
                      ? FamilyMemberAction.leave
                      : FamilyMemberAction.remove,
                  canEdit: member.role == FamilyRole.owner,
                  familyId: familyId,
                  userId: member.userId,
                ),
                child: Icon(Icons.login, size: 20, color: Colors.red),
              ),
            ],

            if (member.isCurrentUser && member.role != FamilyRole.owner) ...[
              WBox(10),
              GestureDetector(
                onTap: () => showLeaveFamilyDialog(
                  context,
                  action: FamilyMemberAction.leave,
                  canEdit: member.role == FamilyRole.owner,
                  familyId: familyId,
                  userId: member.userId,
                ),
                child: Icon(Icons.login, size: 20, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
