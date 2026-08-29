import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entity/card_entity.dart';
import '../../dto/card_dto.dart';
import 'i_card_remote_data_source.dart';

final class CardRemoteDataSource implements ICardRemoteDataSource {
  const CardRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  /// Сервис удалённой бд.
  final FirebaseFirestore _firestore;

  @override
  Future<void> addCard({required String familyId, required CardEntity card}) =>
      _collection(familyId).doc(card.id).set(card.toDto().toJson());

  @override
  Future<void> deleteCard({required String familyId, required String cardId}) =>
      _collection(familyId).doc(cardId).delete();

  @override
  Future<List<CardDto>> getCards({required String familyId}) async {
    final snapshot = await _collection(familyId).get();

    return snapshot.docs.map((e) => CardDto.fromJson(e.data())).toList();
  }

  /// Возвращает коллекцию карт указанной семьи.
  CollectionReference<Map<String, dynamic>> _collection(String familyId) {
    return _firestore.collection('families').doc(familyId).collection('cards');
  }
}
