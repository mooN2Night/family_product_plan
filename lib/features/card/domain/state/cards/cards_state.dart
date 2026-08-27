part of 'cards_bloc.dart';

/// Базовый класс состояния для покупок.
sealed class CardsState extends Equatable {
  const CardsState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class CardsInitialState extends CardsState {
  const CardsInitialState();
}

/// Состояние загрузки.
final class CardsLoadingState extends CardsState {
  const CardsLoadingState();
}

/// Состояние успешной загрузки.
final class CardsSuccessState extends CardsState {
  const CardsSuccessState({required this.cards});

  /// Список покупок.
  final List<CardEntity> cards;

  @override
  List<Object?> get props => [cards];
}

/// Состояние ошибки.
final class CardsErrorState extends CardsState {
  const CardsErrorState({required this.message});

  /// Текст ошибки
  final String message;

  @override
  List<Object?> get props => [message];
}
