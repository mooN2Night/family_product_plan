import 'package:family_product_plan/app/mapper/app_card_mapper.dart';
import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';

import '../../../../../app/services/database/i_database.dart';
import 'i_card_local_data_source.dart';

final class CardLocalDataSource implements ICardLocalDataSource {
  const CardLocalDataSource({required IDatabase database})
    : _database = database;

  /// Экземпляр локальной базы данных.
  final IDatabase _database;

  @override
  Future<void> addCard(CardEntity card) async {
    await _database.insertCard(card.toCompanion());
  }

  @override
  Future<void> deleteCard(String id) async {
    await _database.deleteCard(id);
  }

  @override
  Future<CardEntity> getCard(String id) async {
    final card = await _database.getCard(id);
    return card.toEntity();
  }

  @override
  Future<List<CardEntity>> getCards() async {
    final cards = await _database.getCards();
    return cards.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> replaceCards(List<CardEntity> cards) async {
    await _database.replaceCards(
      cards.map((e) => e.toDatabaseModel()).toList(),
    );
  }
}
