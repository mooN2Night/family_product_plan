/// Роль участника семьи.
enum FamilyRole {
  /// Создатель семьи.
  owner,

  /// Обычный участник.
  member;

  @override
  String toString() {
    return switch (this) {
      FamilyRole.owner => 'owner',
      FamilyRole.member => 'member',
    };
  }

  /// Метод для преобразования из серверного хранения в информация для приложения.
  static FamilyRole fromString(String value) {
    return switch (value) {
      'owner' => FamilyRole.owner,
      'member' => FamilyRole.member,
      _ => FamilyRole.member,
    };
  }

  /// Получения текстовой метки.
  String get title {
    return switch (this) {
      FamilyRole.owner => 'Создатель',
      FamilyRole.member => 'Участник',
    };
  }
}
