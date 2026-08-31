import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_box.dart';

/// Строка с тумблером «Нужно купить».
class AppToggleTile extends StatelessWidget {
  const AppToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: _ProductStatus(isToBuy: value)),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ProductStatus extends StatelessWidget {
  const _ProductStatus({required this.isToBuy});

  final bool isToBuy;

  @override
  Widget build(BuildContext context) {
    final color = isToBuy ? Colors.orange : Colors.green;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCrossFade(
          firstChild: Icon(
            Icons.shopping_cart_outlined,
            size: 18,
            color: color,
          ),
          secondChild: Icon(Icons.check_circle_outline, size: 18, color: color),
          duration: const Duration(milliseconds: 300),
          crossFadeState: isToBuy
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
        const WBox(8),
        AnimatedCrossFade(
          firstChild: Text(
            'Нужно купить',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          secondChild: Text(
            'Покупать не нужно',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          duration: const Duration(milliseconds: 300),
          crossFadeState: isToBuy
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
      ],
    );
  }
}
