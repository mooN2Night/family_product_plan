/// Интерфейс для хранения и получения идентификатора текущей выбранной семьи.
abstract interface class ICurrentFamilyProvider {
  /// Возвращает идентификатор текущей семьи.
  Future<String?> getCurrentFamilyId();

  /// Сохраняет идентификатор текущей семьи.
  Future<void> setCurrentFamilyId(String? familyId);

  /// Удаляет информацию о текущей выбранной семье.
  Future<void> clearCurrentFamilyId();

  /// Поток, уведомляющий об изменении текущей выбранной семьи.
  Stream<String?> watchCurrentFamilyId();
}
