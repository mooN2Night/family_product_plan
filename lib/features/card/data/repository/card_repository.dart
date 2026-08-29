import 'dart:async';

import 'package:family_product_plan/features/card/data/data_source/local/i_card_local_data_source.dart';
import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';

import 'package:family_product_plan/features/card/domain/entity/create_card_entity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/services/family/i_current_family_provider.dart';
import '../../../../app/services/network/i_network_service.dart';
import '../../domain/entity/card_exception.dart';
import '../../domain/repository/i_card_repository.dart';
import '../data_source/remote/i_card_remote_data_source.dart';

final class CardRepository implements ICardRepository {
  CardRepository({
    required INetworkService networkService,
    required ICardLocalDataSource localDataSource,
    required ICardRemoteDataSource remoteDataSource,
    required ICurrentFamilyProvider currentFamilyProvider,
  }) : _networkService = networkService,
       _remoteDataSource = remoteDataSource,
       _currentFamilyProvider = currentFamilyProvider,
       _localDataSource = localDataSource;

  /// Локальный источник данных.
  final ICardLocalDataSource _localDataSource;

  /// Удалённый источник данных.
  final ICardRemoteDataSource _remoteDataSource;

  /// Сервис проверки интернет-соединения.
  final INetworkService _networkService;

  /// Провайдер текущей выбранной семьи.
  final ICurrentFamilyProvider _currentFamilyProvider;

  /// Генератор уникальных идентификаторов.
  static const _uuid = Uuid();

  /// Таймаут на запрос списка карт с сервера — чтобы плохой инет не "морозил" фоновый sync надолго.
  static const _syncTimeout = Duration(seconds: 8);

  /// Не даём двум синхронизациям бежать параллельно (например, если getCards()
  /// вызвали несколько раз подряд).
  bool _syncInProgress = false;

  final _cardsChangedController = StreamController<void>.broadcast();

  @override
  Stream<void> get onCardsChanged => _cardsChangedController.stream;

  @override
  Future<void> addCard(CreateCardEntity createCard) async {
    if (!await _networkService.hasInternet()) {
      throw const AddCardNoInternetException();
    }

    final familyId = await _familyId();
    final card = CardEntity(
      id: _uuid.v4(),
      name: createCard.name,
      number: createCard.number,
      barcodeFormat: createCard.barcodeFormat,
      code: createCard.code,
    );

    await _localDataSource.addCard(card);
    if (familyId != null) {
      await _remoteDataSource.addCard(familyId: familyId, card: card);
    }
  }

  @override
  Future<List<CardEntity>> getCards() async {
    final localCards = await _localDataSource.getCards();

    // Не блокируем ответ — обновление уйдёт в фон и придёт отдельным пингом.
    unawaited(_backgroundSync());

    return localCards;
  }

  @override
  Future<CardEntity> getCard(String id) => _localDataSource.getCard(id);

  @override
  Future<void> deleteCard(String id) async {
    if (!await _networkService.hasInternet()) {
      throw const DeleteCardNoInternetException();
    }

    final familyId = await _familyId();
    await _localDataSource.deleteCard(id);
    if (familyId != null) {
      await _remoteDataSource.deleteCard(familyId: familyId, cardId: id);
    }
  }

  @override
  Future<bool> syncCards() async {
    if (!await _networkService.hasInternet()) return false;

    final familyId = await _familyId();
    if (familyId == null) return false;

    try {
      final remoteCards = await _remoteDataSource
          .getCards(familyId: familyId)
          .timeout(_syncTimeout);

      final entities = remoteCards.map((e) => e.toEntity()).toList();
      final localCards = await _localDataSource.getCards();

      if (_sameIds(localCards, entities)) return false;

      await _localDataSource.replaceCards(entities);
      return true;
    } on Object catch (error) {
      // Плохой инет / таймаут — молча остаёмся на локальных данных.
      debugPrint('Card sync error: $error');
      return false;
    }
  }

  /// Возвращает идентификатор текущей семьи.
  Future<String?> _familyId() => _currentFamilyProvider.getCurrentFamilyId();

  Future<void> _backgroundSync() async {
    if (_syncInProgress) return;
    _syncInProgress = true;
    try {
      final changed = await syncCards();
      if (changed) {
        _cardsChangedController.add(null);
      }
    } finally {
      _syncInProgress = false;
    }
  }

  bool _sameIds(List<CardEntity> local, List<CardEntity> remote) {
    final localIds = local.map((e) => e.id).toSet();
    final remoteIds = remote.map((e) => e.id).toSet();
    return localIds.length == remoteIds.length &&
        localIds.difference(remoteIds).isEmpty;
  }

  @override
  void dispose() {
    _cardsChangedController.close();
  }
}
