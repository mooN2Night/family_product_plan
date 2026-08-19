import 'package:flutter/material.dart';

import '../../../../../app/presentation/ui_kit/app_box.dart';

class ProfileAccountActions extends StatelessWidget {
  const ProfileAccountActions({
    required this.onLogout,
    required this.onDelete,
    super.key,
  });

  final VoidCallback onLogout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          _AccountActionTile(
            icon: Icons.logout_outlined,
            title: 'Выйти из аккаунта',
            onTap: onLogout,
          ),

          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),

          _AccountActionTile(
            icon: Icons.delete_outline,
            title: 'Удалить аккаунт',
            isDestructive: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _AccountActionTile extends StatelessWidget {
  const _AccountActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const WBox(14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
