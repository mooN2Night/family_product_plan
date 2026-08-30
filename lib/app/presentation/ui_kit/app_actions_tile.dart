import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_box.dart';

/// Базовая строка кит-полей: иконка в кружке, подпись сверху, значение снизу,
/// иконка-триггер справа. Используется напрямую для тап-полей (например, выбор
/// даты) и как основа для [AppDropdownField].
class AppActionTile extends StatelessWidget {
  const AppActionTile({
    required this.icon,
    required this.value,
    this.label,
    this.onTap,
    this.trailingIcon,
    this.valueColor,
    super.key,
  });

  /// Иконка слева.
  final IconData icon;

  /// Подпись над значением.
  final String? label;

  /// Текущее отображаемое значение.
  final String value;

  /// Обработчик тапа по всей строке.
  final VoidCallback? onTap;

  /// Иконка справа, обозначающая, что строка кликабельна.
  final IconData? trailingIcon;

  /// Цвет текста значения. По умолчанию [AppColors.textPrimary].
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const WBox(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) ...[
                    Text(
                      label!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const HBox(2),
                  ],
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 17,
                      color: valueColor ?? AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
