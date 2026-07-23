import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../domain/entity/family_entity.dart';
import '../../domain/entity/family_member_info_entity.dart';
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(family.name, style: Theme.of(context).textTheme.headlineMedium),
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
                  await Clipboard.setData(ClipboardData(text: family.joinCode));

                  if (context.mounted) {
                    AppSnackBar.showSuccess(
                      context: context,
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
          (member) => FamilyInfoMemberTile(member: member, familyId: familyId),
        ),
      ],
    );
  }
}
