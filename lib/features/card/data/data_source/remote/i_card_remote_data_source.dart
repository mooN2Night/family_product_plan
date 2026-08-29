import '../../../domain/entity/card_entity.dart';
import '../../dto/card_dto.dart';

abstract interface class ICardRemoteDataSource {
  Future<void> addCard({required String familyId, required CardEntity card});

  Future<void> deleteCard({required String familyId, required String cardId});

  Future<List<CardDto>> getCards({required String familyId});
}
