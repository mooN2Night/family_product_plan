import 'package:flutter/widgets.dart';

/// Виджет для создания вертикального отступа.
class HBox extends SizedBox {
  const HBox(double height, {super.key}) : super(height: height);
}

/// Виджет для создания горизонтального отступа.
class WBox extends SizedBox {
  const WBox(double width, {super.key}) : super(width: width);
}

/// Класс для реализации виджета отступа с заданной высотой и шириной.
class HWBox extends SizedBox {
  const HWBox(double height, double width, {super.key})
    : super(height: height, width: width);

  /// Создает виджет отступа с нулевой высотой и шириной.
  /// Эквивалентно использованию `SizedBox.shrink()`.
  const HWBox.shrink({super.key}) : super.shrink();
}

/// Класс для реализации виджета-сливера вертикального отступа с заданной высотой.
class SliverHBox extends StatelessWidget {
  const SliverHBox(this.size, {super.key});

  /// Высота вертикального отступа.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(padding: EdgeInsets.only(top: size));
  }
}

/// Класс для реализации виджета-сливера горизонтального отступа с заданной шириной.
class SliverWBox extends StatelessWidget {
  const SliverWBox(this.size, {super.key});

  /// Ширина горизонтального отступа.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(padding: EdgeInsets.only(left: size));
  }
}
