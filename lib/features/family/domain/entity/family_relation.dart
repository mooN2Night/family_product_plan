/// Родственная связь.
enum FamilyRelation {
  /// Не определена.
  undefined,

  /// Папа.
  father,

  /// Мама.
  mother,

  /// Сын.
  son,

  /// Дочь.
  daughter,

  /// Бабушка.
  grandfather,

  /// Дедушка.
  grandmother;

  @override
  String toString() {
    return switch (this) {
      FamilyRelation.undefined => 'undefined',
      FamilyRelation.father => 'father',
      FamilyRelation.mother => 'mother',
      FamilyRelation.son => 'son',
      FamilyRelation.daughter => 'daughter',
      FamilyRelation.grandfather => 'grandfather',
      FamilyRelation.grandmother => 'grandmother',
    };
  }

  /// Метод для преобразования из серверного хранения в информация для приложения.
  static FamilyRelation fromString(String value) {
    return switch (value) {
      'father' => FamilyRelation.father,
      'mother' => FamilyRelation.mother,
      'son' => FamilyRelation.son,
      'daughter' => FamilyRelation.daughter,
      'grandfather' => FamilyRelation.grandfather,
      'grandmother' => FamilyRelation.grandmother,
      _ => FamilyRelation.undefined,
    };
  }

  /// Получения текстовой метки.
  String get title {
    return switch (this) {
      FamilyRelation.undefined => 'Не указано',
      FamilyRelation.father => 'Папа',
      FamilyRelation.mother => 'Мама',
      FamilyRelation.son => 'Сын',
      FamilyRelation.daughter => 'Дочь',
      FamilyRelation.grandfather => 'Дедушка',
      FamilyRelation.grandmother => 'Бабушка',
    };
  }
}
