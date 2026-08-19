import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:flutter/material.dart';

import '../../../../app/utils/app_colors.dart';

class TasksErrorCard extends StatelessWidget {
  const TasksErrorCard({super.key, required this.message, required this.onTap});

  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.primary),
              const WBox(12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          HBox(10),
          TextButton(onPressed: () => onTap, child: Text('Обновить')),
        ],
      ),
    );
  }
}
