import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/card_entity.dart';
import '../../repository/i_card_repository.dart';

part 'cards_event.dart';

part 'cards_state.dart';

/// Блок управлением состоянием главного экрана
class CardsBloc extends Bloc<CardsEvent, CardsState> {
  CardsBloc({required ICardRepository cardRepository})
    : _cardRepository = cardRepository,
      super(const CardsInitialState()) {
    on<CardsFetchEvent>(_fetchCards);
  }

  /// Репозиторий для запросов
  final ICardRepository _cardRepository;

  /// Запускает наблюдение за изменениями списка продуктов.
  Future<void> _fetchCards(
    CardsFetchEvent event,
    Emitter<CardsState> emit,
  ) async {
    if (state is CardsLoadingState) return;
    emit(const CardsLoadingState());

    try {
      final cards = await _cardRepository.getCards();
      emit(CardsSuccessState(cards: cards));
    } on AppException catch (error, stackTrace) {
      emit(CardsErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
