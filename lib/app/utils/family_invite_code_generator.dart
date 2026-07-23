import 'dart:math';

/// Класс для создания рандомного значения кода для встепления в семью.
abstract final class FamilyInviteCodeGenerator {
  /// Доступные символы.
  static const _symbols =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  /// Рандомное значение.
  static final _random = Random.secure();

  /// Метод для генерации кода для вступления в семью.
  static String generate() {
    final length = 4 + _random.nextInt(8); // 4..12 символов

    return List.generate(
      length,
      (_) => _symbols[_random.nextInt(_symbols.length)],
    ).join();
  }
}
