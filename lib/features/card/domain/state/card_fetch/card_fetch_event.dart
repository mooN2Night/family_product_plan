part of 'card_fetch_bloc.dart';

/// Класс базового события.
sealed class CardFetchEvent extends Equatable {
  const CardFetchEvent();

  @override
  List<Object?> get props => [];
}

/// Класс события получения списка скидочных карточек.
final class CardFetchRequestedEvent extends CardFetchEvent {
  const CardFetchRequestedEvent({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
