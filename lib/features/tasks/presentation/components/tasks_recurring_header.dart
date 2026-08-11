import 'package:flutter/material.dart';

import '../../../../app/utils/app_colors.dart';

class TasksRecurringHeader extends StatelessWidget {
  const TasksRecurringHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Повторяющиеся',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
