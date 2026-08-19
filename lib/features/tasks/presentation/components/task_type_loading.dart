import 'package:flutter/material.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/presentation/ui_kit/app_skeleton.dart';
import '../../../../app/utils/app_colors.dart';

class TodayTaskLoadingView extends StatelessWidget {
  const TodayTaskLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Text(
                'Сегодня',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            AppSkeleton(width: 80, height: 20),
          ],
        ),
        const HBox(16),
        AppSkeleton(width: double.infinity, height: 80),
        const HBox(16),
        AppSkeleton(width: double.infinity, height: 60),
        const HBox(16),
        AppSkeleton(width: double.infinity, height: 60),
      ],
    );
  }
}

class OneTimeTaskLoadingView extends StatelessWidget {
  const OneTimeTaskLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Разовые задачи',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const HBox(16),
        AppSkeleton(width: double.infinity, height: 60),
        const HBox(16),
        AppSkeleton(width: double.infinity, height: 60),
      ],
    );
  }
}

class RepeatingTaskLoadingView extends StatelessWidget {
  const RepeatingTaskLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(width: double.infinity, height: 60),
      ],
    );
  }
}
