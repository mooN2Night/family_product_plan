/// Тип приоритета задачи
enum TaskPriority {
  /// Низкий приоритет
  low,

  /// Средний приоритет
  medium,

  /// Высокий приоритет
  high,

  /// Срочные
  urgent;

  @override
  String toString() {
    return switch (this) {
      TaskPriority.low => 'low',
      TaskPriority.medium => 'medium',
      TaskPriority.high => 'high',
      TaskPriority.urgent => 'urgent',
    };
  }

  /// Метод для преобразования из серверного хранения в информация для приложения.
  static TaskPriority fromString(String value) {
    return switch (value) {
      'low' => TaskPriority.low,
      'medium' => TaskPriority.medium,
      'high' => TaskPriority.high,
      'urgent' => TaskPriority.urgent,
      _ => TaskPriority.low,
    };
  }

  /// Получения текстовой метки.
  String get title {
    return switch (this) {
      TaskPriority.low => 'Низкий приоритет',
      TaskPriority.medium => 'Средний приоритет',
      TaskPriority.high => 'Высокий приоритет',
      TaskPriority.urgent => 'Срочные',
    };
  }
}
