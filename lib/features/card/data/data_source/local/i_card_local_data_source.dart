import '../../../domain/entity/card_entity.dart';

/// Интерфейс локального источника данных для работы с продуктами.
abstract interface class ICardLocalDataSource {
  /// Добавление новой карты
  Future<void> addCard(CardEntity card);

  /// Получение всех карт
  Future<List<CardEntity>> getCards();

  /// Получение карты
  Future<CardEntity> getCard(String id);

  /// Удаление карты
  Future<void> deleteCard(String id);

  /// Полностью заменяет локальный список карт данными с сервера.
  Future<void> replaceCards(List<CardEntity> cards);
}
