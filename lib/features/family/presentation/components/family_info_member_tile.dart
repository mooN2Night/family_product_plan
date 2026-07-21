import 'package:flutter/material.dart';

import '../../domain/entity/family_member_info_entity.dart';
import '../../domain/entity/family_role.dart';

/// Виджет отображения карточки участника семьи.
class FamilyInfoMemberTile extends StatelessWidget {
  const FamilyInfoMemberTile({required this.member, super.key});

  /// Информация об участнике.
  final FamilyMemberInfoEntity member;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(member.fullName),
        subtitle: Text(member.relation.title),
        trailing: member.role == FamilyRole.owner
            ? Text(FamilyRole.owner.title)
            : null,
      ),
    );
  }
}
