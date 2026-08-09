/// Тип задачи
enum TaskType {
  /// Разовая
  oneTime,

  /// Ежедневная
  daily,

  /// Еженедельная
  weekly,

  /// Ежемесячная
  monthly,

  /// Ежегодная
  yearly;

  @override
  String toString() {
    return switch (this) {
      TaskType.oneTime => 'oneTime',
      TaskType.daily => 'daily',
      TaskType.weekly => 'weekly',
      TaskType.monthly => 'monthly',
      TaskType.yearly => 'yearly',
    };
  }

  /// Метод для преобразования из серверного хранения в информация для приложения.
  static TaskType fromString(String value) {
    return switch (value) {
      'oneTime' => TaskType.oneTime,
      'daily' => TaskType.daily,
      'weekly' => TaskType.weekly,
      'monthly' => TaskType.monthly,
      'yearly' => TaskType.yearly,
      _ => TaskType.oneTime,
    };
  }

  /// Получения текстовой метки.
  String get title {
    return switch (this) {
      TaskType.oneTime => 'Разовые',
      TaskType.daily => 'Ежедневные',
      TaskType.weekly => 'Еженедельные',
      TaskType.monthly => 'Ежемесячные',
      TaskType.yearly => 'Ежегодные',
    };
  }
}
