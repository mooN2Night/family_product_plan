import '../entity/card_entity.dart';
import '../entity/create_card_entity.dart';

/// Интерфейс репозитория экрана скидочных карточек
abstract interface class ICardRepository {
  /// Добавление новой карты
  Future<void> addCard(CreateCardEntity createCard);

  /// Получение всех карт
  Future<List<CardEntity>> getCards();

  /// Получение карты
  Future<CardEntity> getCard(String id);

  /// Удаление карты
  Future<void> deleteCard(String id);
}