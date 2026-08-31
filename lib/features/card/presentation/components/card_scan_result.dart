import 'package:flutter/material.dart';

import '../../../../app/presentation/ui_kit/app_actions_tile.dart';
import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/presentation/ui_kit/app_field_group.dart';
import '../../../../app/utils/app_colors.dart';
import '../../utils/card_scanner_result.dart';

/// Карточка результата сканирования карты.
///
/// До скана выглядит как обычный тап-филд ([AppActionTile]), приглашающий
/// отсканировать штрихкод. После скана превращается в карточку с галкой,
/// форматом штрихкода и кнопкой пересканировать — результат остаётся видимым
/// на экране, а не мелькает один раз в снекбаре.
class AppScanResultCard extends StatelessWidget {
  const AppScanResultCard({
    required this.result,
    required this.onScan,
    super.key,
  });

  /// Результат последнего скана, `null` — если карта ещё не отсканирована.
  final ScannedCardResult? result;

  /// Вызывается и для первичного скана, и для пересканирования.
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final result = this.result;

    if (result == null) {
      return AppFieldGroup(
        children: [
          AppActionTile(
            icon: Icons.qr_code_scanner_outlined,
            label: 'Штрихкод карты',
            value: 'Не отсканирован',
            trailingIcon: Icons.chevron_right_rounded,
            onTap: onScan,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 22,
            ),
            const WBox(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Карта отсканирована',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onScan,
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              tooltip: 'Пересканировать',
            ),
          ],
        ),
      ),
    );
  }
}
