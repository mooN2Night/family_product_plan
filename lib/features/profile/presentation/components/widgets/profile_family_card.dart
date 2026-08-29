import 'package:family_product_plan/app/presentation/ui_kit/app_skeleton.dart';
import 'package:family_product_plan/features/family/domain/state/family_fetch/family_fetch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/presentation/ui_kit/app_box.dart';

class ProfileFamilyCard extends StatelessWidget {
  const ProfileFamilyCard({
    required this.onTap,
    required this.familyId,
    super.key,
  });

  final VoidCallback onTap;
  final String familyId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Builder(
      builder: (context) {
        return Material(
          color: colorScheme.primaryContainer.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(24),
          child: BlocBuilder<FamilyFetchBloc, FamilyFetchState>(
            builder: (context, state) {
              return InkWell(
                onTap: switch (state) {
                  FamilyFetchLoadingState() => null,
                  FamilyFetchErrorState() =>
                    () => context.read<FamilyFetchBloc>().add(
                      FamilyFetchRequestedEvent(familyId: familyId),
                    ),
                  FamilyFetchSuccessState() => onTap,
                  _ => null,
                },
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.family_restroom_outlined,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const WBox(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ваша семья',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const HBox(3),
                            switch (state) {
                              FamilyFetchLoadingState() => AppSkeleton(
                                width: 150,
                              ),
                              FamilyFetchSuccessState() => Text(
                                state.family.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              FamilyFetchErrorState() => Text(
                                'Ошибка загрузки. Нажмите на эту карточку для перезагрузки',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              _ => SizedBox.shrink(),
                            },
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
