import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_actions_tile.dart';
import 'app_box.dart';

/// Замена стандартному [DropdownButtonFormField]: выглядит как [AppTextField]
/// / [AppActionTile], а выбор происходит через нижний шит вместо платформенного
/// меню — за счёт этого одинаково хорошо смотрится и на Android, и на iOS.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    super.key,
  });

  final IconData icon;
  final String label;
  final T value;
  final List<T> items;
  final String Function(T item) itemLabelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppActionTile(
      icon: icon,
      label: label,
      value: itemLabelBuilder(value),
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      onTap: () => _openPicker(context),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HBox(12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const HBox(16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const HBox(4),
              ...items.map((item) {
                final isSelected = item == value;

                return ListTile(
                  onTap: () => Navigator.of(sheetContext).pop(item),
                  title: Text(
                    itemLabelBuilder(item),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                );
              }),
              const HBox(8),
            ],
          ),
        );
      },
    );

    if (result != null) onChanged(result);
  }
}
