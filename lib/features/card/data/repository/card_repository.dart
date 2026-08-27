import 'package:family_product_plan/features/card/data/data_source/local/i_card_local_data_source.dart';
import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';

import 'package:family_product_plan/features/card/domain/entity/create_card_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/services/network/i_network_service.dart';
import '../../../../app/services/pending_sync/i_pending_sync_service.dart';
import '../../domain/repository/i_card_repository.dart';

final class CardRepository implements ICardRepository {
  const CardRepository({
    required IPendingSyncService pendingSyncService,
    required INetworkService networkService,
    required ICardLocalDataSource localDataSource,
  }) : _pendingSyncService = pendingSyncService,
       _networkService = networkService,
       _localDataSource = localDataSource;

  final ICardLocalDataSource _localDataSource;

  /// Провайдер текущей выбранной семьи.
  final INetworkService _networkService;

  /// Провайдер текущей выбранной семьи.
  final IPendingSyncService _pendingSyncService;

  /// Генератор уникальных идентификаторов.
  static const _uuid = Uuid();

  @override
  Future<void> addCard(CreateCardEntity createCard) async {
    final card = CardEntity(
      id: _uuid.v4(),
      name: createCard.name,
      number: createCard.number,
    );

    await _localDataSource.addCard(card);
    // if (await _networkService.hasInternet()) {
    //   unawaited(_syncAdd(entity));
    // } else {
    //   await _pendingSyncService.enqueueProductAdd(entity);
    // }
  }

  @override
  Future<List<CardEntity>> getCards() async =>
      await _localDataSource.getCards();

  @override
  Future<CardEntity> getCard(String id) async =>
      await _localDataSource.getCard(id);

  @override
  Future<void> deleteCard(String id) async {
    // if (await _networkService.hasInternet()) {
    await _localDataSource.deleteCard(id);
    // } else {
    // TODO: тут просто бросить исключение в виде "Нет интеренета, попробуйте удалить позже"
    // }
  }
}
