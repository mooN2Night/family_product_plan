import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/family/domain/state/family_remove_member_bloc/family_remove_member_bloc.dart';
import '../../features/family/utils/family_member_action.dart';

Future<bool?> showLeaveFamilyDialog(
    BuildContext context, {
      required FamilyMemberAction action,
      required bool canEdit,
      required String familyId,
      required String userId,
    }) {
  final title = switch (action) {
    FamilyMemberAction.leave => 'Выйти из семьи?',
    FamilyMemberAction.remove => 'Удалить участника?',
  };

  final content = switch (action) {
    FamilyMemberAction.leave =>
    'После выхода вы потеряете доступ к общему списку покупок.',
    FamilyMemberAction.remove =>
    'Участник будет удалён из семьи и потеряет доступ к общему списку покупок.',
  };

  final buttonText = switch (action) {
    FamilyMemberAction.leave => 'Выйти',
    FamilyMemberAction.remove => 'Удалить',
  };

  return canEdit
      ? showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text('Вы не можете удалить себя из семьи'),
        content: Text(
          'Вы являетесь владельцем семьи, поэтому вы не можете удалить себя. Сначала передайте права другому',
        ),
        actions: [
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              switch (action) {
                case FamilyMemberAction.leave:
                // TODO: придумать как передать права
                  break;
                case FamilyMemberAction.remove:
                  context.read<FamilyRemoveMemberBloc>().add(
                    FamilyRemoveMemberOtherEvent(
                      familyId: familyId,
                      userId: userId,
                    ),
                  );
                  break;
              }

              context.pop();
            },
            child: Text('Передать права'),
          ),
        ],
      );
    },
  )
      : showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              switch (action) {
                case FamilyMemberAction.leave:
                  context.read<FamilyRemoveMemberBloc>().add(
                    FamilyRemoveMemberYourselfEvent(familyId: familyId),
                  );
                  break;
                case FamilyMemberAction.remove:
                  context.read<FamilyRemoveMemberBloc>().add(
                    FamilyRemoveMemberOtherEvent(
                      familyId: familyId,
                      userId: userId,
                    ),
                  );
                  break;
              }

              context.pop();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}