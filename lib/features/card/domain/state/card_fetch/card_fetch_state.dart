part of 'card_fetch_bloc.dart';

/// Базовый класс состояния для покупок.
sealed class CardFetchState extends Equatable {
  const CardFetchState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class CardFetchInitialState extends CardFetchState {
  const CardFetchInitialState();
}

/// Состояние загрузки.
final class CardFetchLoadingState extends CardFetchState {
  const CardFetchLoadingState();
}

/// Состояние успешной загрузки.
final class CardFetchSuccessState extends CardFetchState {
  const CardFetchSuccessState({required this.card});

  final CardEntity card;

  @override
  List<Object?> get props => [card];
}

/// Состояние ошибки.
final class CardFetchErrorState extends CardFetchState {
  const CardFetchErrorState({required this.message});

  /// Текст ошибки
  final String message;

  @override
  List<Object?> get props => [message];
}
