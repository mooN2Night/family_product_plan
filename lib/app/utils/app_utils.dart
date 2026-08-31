import 'package:intl/intl.dart';

/// Класс для реализации доступа к утилитам приложения.
abstract class AppUtils {
  /// Метод для получения множественного числа для строки.
  ///
  /// ```
  /// print(AppUtils.pluralizeString(1, one: 'новость', few: 'новости', many: 'новостей', other: 'новостей')) // новость
  /// print(AppUtils.pluralizeString(2, one: 'новость', few: 'новости', many: 'новостей', other: 'новостей')) // новости
  /// print(AppUtils.pluralizeString(5, one: 'новость', few: 'новости', many: 'новостей', other: 'новостей')) // новостей
  /// ```
  /// Принимает:
  /// - [count] - количество элементов множественного числа строки
  /// - [one] - форма единственного числа
  /// - [few] - форма множественного числа от 2 до 4
  /// - [many] - форма множественного числа от 5 и более
  /// - [other] - форма множественного числа по умолчанию
  static String pluralizeString(
    int count, {
    required String other,
    String? one,
    String? few,
    String? many,
  }) {
    final formatted = Intl.plural(
      locale: 'ru',
      count,
      one: one,
      few: few,
      many: many,
      other: other,
    );
    return formatted;
  }

  static String? formatDate(DateTime? date) {
    if (date != null) return DateFormat('dd MMMM yyyy', 'ru').format(date);

    return null;
  }

  static String? formatTime(DateTime? date) {
    if (date != null) return DateFormat('HH:mm:ss', 'ru').format(date);

    return null;
  }
}
