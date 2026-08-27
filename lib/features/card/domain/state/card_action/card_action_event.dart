part of 'card_action_bloc.dart';

/// Класс базового события.
sealed class CardActionEvent extends Equatable {
  const CardActionEvent();

  @override
  List<Object?> get props => [];
}

/// Класс события получения списка скидочных карточек.
final class CardActionAddEvent extends CardActionEvent {
  const CardActionAddEvent({required this.card});

  final CreateCardEntity card;

  @override
  List<Object?> get props => [card];
}

/// Класс события получения списка скидочных карточек.
final class CardActionDeleteEvent extends CardActionEvent {
  const CardActionDeleteEvent({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
