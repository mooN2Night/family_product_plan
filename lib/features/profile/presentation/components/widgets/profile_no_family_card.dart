import 'package:flutter/material.dart';

import '../../../../../app/presentation/ui_kit/app_box.dart';

class ProfileNoFamilyCard extends StatelessWidget {
  const ProfileNoFamilyCard({
    super.key,
    required this.onCreateFamily,
    required this.onJoinFamily,
  });

  final VoidCallback onCreateFamily;
  final VoidCallback onJoinFamily;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
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
                      'Семьи пока нет',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Создайте свою или присоединитесь к существующей',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const HBox(18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onCreateFamily,
              child: const Text('Создать семью'),
            ),
          ),
          const HBox(8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onJoinFamily,
              child: const Text('Присоединиться'),
            ),
          ),
        ],
      ),
    );
  }
}
