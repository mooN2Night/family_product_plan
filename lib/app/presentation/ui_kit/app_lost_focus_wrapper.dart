import 'package:flutter/material.dart';

/// Класс для реализации обертки сброса фокуса при тапе на пустое пространство.
class AppLostFocusWrapper extends StatelessWidget {
  const AppLostFocusWrapper({required this.child, super.key});

  /// Виджет, который будет обернут в [GestureDetector]
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: FocusScope.of(context).unfocus,
    behavior: HitTestBehavior.opaque,
    child: child,
  );
}