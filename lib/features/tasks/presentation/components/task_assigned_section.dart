import 'package:family_product_plan/app/presentation/ui_kit/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import '../../../../app/presentation/ui_kit/app_field_group.dart';
import '../../../family/domain/entity/family_member_info_entity.dart';

class TaskAssignedWidget extends StatelessWidget {
  const TaskAssignedWidget({
    required this.assignedUserNotifier,
    required this.members,
    required this.doesNotAssigned,
    super.key,
  });

  final ValueNotifier<FamilyMemberInfoEntity?> assignedUserNotifier;
  final List<FamilyMemberInfoEntity> members;
  final String doesNotAssigned;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppFieldDivider(),
        ValueListenableBuilder<FamilyMemberInfoEntity?>(
          valueListenable: assignedUserNotifier,
          builder: (context, assignedUserId, _) {
            return AppDropdownField<FamilyMemberInfoEntity?>(
              icon: Icons.person_outline,
              label: 'Назначит на',
              value: assignedUserNotifier.value,
              items: [null, ...members],
              itemLabelBuilder: (person) {
                if (person == null) return doesNotAssigned;

                final member = members.firstWhere(
                  (m) => m.userId == person.userId,
                );
                return '${member.lastName} ${member.firstName}';
              },
              onChanged: (value) => assignedUserNotifier.value = value,
            );
          },
        ),
      ],
    );
  }
}
