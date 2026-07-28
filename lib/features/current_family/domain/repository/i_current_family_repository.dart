/// Интерфейс репозитория получения текущего id семьи.
abstract interface class ICurrentFamilyRepository {
  /// Метод для поулчения текущего id семьи.
  Future<String?> getCurrentFamily();

  /// Метод для поулчения потока инфорации наличие семьи у пользователя.
  Stream<String?> watchCurrentFamily();

  /// Метод для обновления данных о семье.
  Future<void> refresh();

  /// Метод для добавлении данных о семье.
  Future<void> setCurrentFamily(String? familyId);

  /// Метод для очистки данных о семье.
  Future<void> clear();
}
