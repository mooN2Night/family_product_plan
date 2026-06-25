import 'package:flutter/widgets.dart';

/// Виджет для создания вертикального отступа.
class HBox extends SizedBox {
  const HBox(double height, {super.key}) : super(height: height);
}

/// Виджет для создания горизонтального отступа.
class WBox extends SizedBox {
  const WBox(double width, {super.key}) : super(width: width);
}
