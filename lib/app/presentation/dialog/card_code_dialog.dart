import 'package:flutter/material.dart';

import '../../../features/card/domain/entity/card_entity.dart';
import '../../../features/card/presentation/components/widgets/card_code_image.dart';
import '../../app_context_ext.dart';
import '../../utils/app_colors.dart';
import '../ui_kit/app_box.dart';

/// Открывает код карты на весь экран поверх остального контента и на время
/// показа выкручивает яркость экрана на максимум — чтобы сканеру на кассе
/// было проще считать код. Яркость возвращается к исходной после закрытия
/// независимо от того, как диалог был закрыт.
Future<void> showCardCodeDialog(BuildContext context, CardEntity card) async {
  final screenBrightness = context.di.services.screenBrightnessService;

  await screenBrightness.setMaxApplicationBrightness();

  if (!context.mounted) {
    await screenBrightness.resetApplicationBrightness();
    return;
  }

  try {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _CardCodeDialog(card: card),
    );
  } finally {
    await screenBrightness.resetApplicationBrightness();
  }
}

class _CardCodeDialog extends StatelessWidget {
  const _CardCodeDialog({required this.card});

  final CardEntity card;

  @override
  Widget build(BuildContext context) {
    final hasNumber = card.number.trim().isNotEmpty;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              card.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (hasNumber) ...[
              const HBox(4),
              Text(
                card.number,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const HBox(20),
            SizedBox(
              width: 240,
              height: 240,
              child: CardCodeImage(card: card, size: 240),
            ),
            const HBox(24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Закрыть',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}