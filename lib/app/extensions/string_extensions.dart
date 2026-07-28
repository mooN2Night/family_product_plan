/// Расширение для преобразования строки в логическое значение.
extension BoolParser on String? {
  /// Возвращает `true`, если строка равна `'true'`, иначе `false`.
  bool toBool() => this == 'true';
}
