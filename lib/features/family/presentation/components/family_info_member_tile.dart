import 'package:family_product_plan/features/family/presentation/family_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entity/family_member_info_entity.dart';
import '../../domain/entity/family_role.dart';

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
          },
        ),
        title: Text(member.fullName),
        subtitle: Text(member.relation.title),
        trailing: member.role == FamilyRole.owner
            ? Text(FamilyRole.owner.title)
            : null,
      ),
    );
  }
}
