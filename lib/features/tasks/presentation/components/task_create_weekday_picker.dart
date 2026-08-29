import 'package:flutter/material.dart';

import '../../../../app/utils/app_colors.dart';
import '../../utils/weekday.dart';

class WeekdayPicker extends StatelessWidget {
  const WeekdayPicker({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Weekday? selected;
  final ValueChanged<Weekday> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Weekday.values.map((day) {
        final isSelected = day == selected;

        return ChoiceChip(
          label: Text(day.shortLabel),
          selected: isSelected,
          onSelected: (_) => onChanged(day),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.primarySoft,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }
}
