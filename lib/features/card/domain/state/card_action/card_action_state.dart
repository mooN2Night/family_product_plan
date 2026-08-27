part of 'card_action_bloc.dart';

/// Базовый класс состояния для покупок.
sealed class CardActionState extends Equatable {
  const CardActionState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class CardActionInitialState extends CardActionState {
  const CardActionInitialState();
}

/// Состояние загрузки.
final class CardActionLoadingState extends CardActionState {
  const CardActionLoadingState();
}

/// Состояние успешной загрузки.
final class CardActionSuccessState extends CardActionState {
  const CardActionSuccessState();
}

/// Состояние ошибки.
final class CardActionErrorState extends CardActionState {
  const CardActionErrorState({required this.message});

  /// Текст ошибки
  final String message;

  @override
  List<Object?> get props => [message];
}
