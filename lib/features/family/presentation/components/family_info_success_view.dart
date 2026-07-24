import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../../profile/presentation/profile_routes.dart';
import '../../domain/entity/family_entity.dart';
import '../../domain/entity/family_member_info_entity.dart';
import '../../domain/entity/family_role.dart';
import '../../domain/state/family_delete_bloc/family_delete_bloc.dart';
import '../../domain/state/family_remove_member_bloc/family_remove_member_bloc.dart';
import '../../utils/family_member_action.dart';
import 'family_info_member_tile.dart';

/// Виджет отображения успешно загруженных данных
class FamilyInfoSuccessView extends StatelessWidget {
  const FamilyInfoSuccessView({
    required this.family,
    required this.familyId,
    required this.members,
    super.key,
  });

  /// Информация о семье.
  final FamilyEntity family;

  /// Уникальный идентификатор семьи.
  final String familyId;

  /// Участники семьи.
  final List<FamilyMemberInfoEntity> members;

  @override
  Widget build(BuildContext context) {
    final currentMember = members.firstWhere((member) => member.isCurrentUser);
    final isOwner = currentMember.role == FamilyRole.owner;

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
              }
            }
          },
        ),

        BlocListener<FamilyDeleteBloc, FamilyDeleteState>(
          listener: (context, state) {
            if (state is FamilyDeleteErrorState) {
              AppSnackBar.showError(context, message: state.message);
            }

            if (state is FamilyDeleteSuccessState) {
              AppSnackBar.showSuccess(context, message: 'Семья удалена');

              context.goNamed(ProfileRoutes.profileScreenName);
            }
          },
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  family.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              if (isOwner)
                IconButton(
                  onPressed: () => _showDeleteFamilyDialog(context),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
          const HBox(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Код приглашения'),
                      const SizedBox(height: 6),
                      SelectableText(
                        family.joinCode,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: family.joinCode),
                    );

                    if (context.mounted) {
                      AppSnackBar.showSuccess(
                        context,
                        message: 'Код скопирован',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const HBox(12),
          Text('Участников: ${members.length}'),
          const HBox(24),
          Text('Участники', style: Theme.of(context).textTheme.titleLarge),
          const HBox(12),
          ...members.map(
            (member) =>
                FamilyInfoMemberTile(member: member, familyId: familyId),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteFamilyDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Удалить семью?'),
          content: const Text(
            'Все участники будут исключены из семьи и потеряют доступ к общему списку покупок. Это действие нельзя отменить.',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Отмена'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<FamilyDeleteBloc>().add(
                  FamilyDeleteRequestedEvent(familyId: familyId),
                );

                context.pop();
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }
}
