import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_box.dart';

/// Строка кит-полей с текстовым инпутом: иконка в кружке, подпись сверху,
/// [TextField] снизу без рамки. Используется внутри [AppFieldGroup].
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.icon,
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    super.key,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final int? minLines;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const WBox(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const HBox(2),
                TextFormField(
                  controller: controller,
                  autofocus: autofocus,
                  maxLines: maxLines,
                  minLines: minLines,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  onChanged: onChanged,
                  validator: validator,
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: AppColors.textInactive,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                // TextField(
                //   controller: controller,
                //   autofocus: autofocus,
                //   maxLines: maxLines,
                //   minLines: minLines,
                //   keyboardType: keyboardType,
                //   textInputAction: textInputAction,
                //   onChanged: onChanged,
                //   style: const TextStyle(
                //     fontSize: 17,
                //     color: AppColors.textPrimary,
                //   ),
                //   decoration: InputDecoration(
                //     isDense: true,
                //     contentPadding: EdgeInsets.zero,
                //     border: InputBorder.none,
                //     hintText: hint,
                //     hintStyle: const TextStyle(
                //       color: AppColors.textInactive,
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}