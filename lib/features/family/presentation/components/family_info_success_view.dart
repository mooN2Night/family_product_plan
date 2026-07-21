import 'package:flutter/material.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../domain/entity/family_entity.dart';
import '../../domain/entity/family_member_info_entity.dart';
import 'family_info_member_tile.dart';

/// Виджет отображения успешно загруженных данных
class FamilyInfoSuccessView extends StatelessWidget {
  const FamilyInfoSuccessView({
    required this.family,
    required this.members,
    super.key,
  });

  final FamilyEntity family;
  final List<FamilyMemberInfoEntity> members;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(family.name, style: Theme.of(context).textTheme.headlineMedium),
        const HBox(8),
        Text('Участников: ${members.length}'),
        const HBox(24),
        Text('Участники', style: Theme.of(context).textTheme.titleLarge),
        const HBox(12),
        ...members.map((member) => FamilyInfoMemberTile(member: member)),
      ],
    );
  }
}
