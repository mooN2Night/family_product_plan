import 'dart:ui';

/// Палитра градиентов для карточек в стиле кошелька.
///
/// Цвета подобраны в тон основному [AppColors.primary]: холодные
/// фиолетово-сине-бирюзовые оттенки составляют костяк, пара тёплых акцентов
/// (коралл, янтарь, малина) добавлены для разнообразия, чтобы карточки
/// не сливались друг с другом при большом их количестве.
abstract final class CardPalette {
  static const List<List<Color>> gradients = [
    [Color(0xFF7048C4), Color(0xFF9B7BE3)],
    [Color(0xFF4C3F91), Color(0xFF7B6FC4)],
    [Color(0xFF3E63C9), Color(0xFF6E93E8)],
    [Color(0xFF2E9CB0), Color(0xFF6BD1DE)],
    [Color(0xFF1F9E7A), Color(0xFF5FD1A8)],
    [Color(0xFF9147C0), Color(0xFFC17BE0)],
    [Color(0xFFD1477E), Color(0xFFF08FB0)],
    [Color(0xFFE0637A), Color(0xFFF5A3B0)],
    [Color(0xFFD79A3B), Color(0xFFF2C15F)],
    [Color(0xFF6C6F93), Color(0xFF9A9DC2)],
  ];

  /// Отдаёт градиент по индексу карточки в списке — цвета раздаются по
  /// кругу палитры в порядке добавления карт, без пересчёта на каждый
  /// ребилд (иначе цвета "прыгали" бы при любом обновлении списка).
  static List<Color> gradientForIndex(int index) {
    return gradients[index % gradients.length];
  }
}
