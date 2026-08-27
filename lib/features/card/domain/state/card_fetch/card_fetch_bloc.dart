import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/card_entity.dart';
import '../../repository/i_card_repository.dart';

part 'card_fetch_event.dart';

part 'card_fetch_state.dart';

/// Блок управлением состоянием главного экрана
class CardFetchBloc extends Bloc<CardFetchEvent, CardFetchState> {
  CardFetchBloc({required ICardRepository cardRepository})
    : _cardRepository = cardRepository,
      super(const CardFetchInitialState()) {
    on<CardFetchRequestedEvent>(_fetchCard);
  }

  /// Репозиторий для запросов
  final ICardRepository _cardRepository;

  /// Запускает наблюдение за изменениями списка продуктов.
  Future<void> _fetchCard(
    CardFetchRequestedEvent event,
    Emitter<CardFetchState> emit,
  ) async {
    if (state is CardFetchLoadingState) return;
    emit(const CardFetchLoadingState());

    try {
      final card = await _cardRepository.getCard(event.id);
      emit(CardFetchSuccessState(card: card));
    } on AppException catch (error, stackTrace) {
      emit(CardFetchErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
