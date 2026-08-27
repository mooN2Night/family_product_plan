import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/card/domain/entity/create_card_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/i_card_repository.dart';

part 'card_action_event.dart';

part 'card_action_state.dart';

/// Блок управлением состоянием главного экрана
class CardActionBloc extends Bloc<CardActionEvent, CardActionState> {
  CardActionBloc({required ICardRepository cardRepository})
    : _cardRepository = cardRepository,
      super(const CardActionInitialState()) {
    on<CardActionAddEvent>(_fetchCard);
    on<CardActionDeleteEvent>(_deleteCard);
  }

  /// Репозиторий для запросов
  final ICardRepository _cardRepository;

  /// Запускает наблюдение за изменениями списка продуктов.
  Future<void> _fetchCard(
    CardActionAddEvent event,
    Emitter<CardActionState> emit,
  ) async {
    if (state is CardActionLoadingState) return;
    emit(const CardActionLoadingState());

    try {
      await _cardRepository.addCard(event.card);
      emit(CardActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(CardActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  /// Запускает наблюдение за изменениями списка продуктов.
  Future<void> _deleteCard(
    CardActionDeleteEvent event,
    Emitter<CardActionState> emit,
  ) async {
    if (state is CardActionLoadingState) return;
    emit(const CardActionLoadingState());

    try {
      await _cardRepository.deleteCard(event.id);
      emit(CardActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(CardActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
