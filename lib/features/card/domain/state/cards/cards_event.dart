part of 'cards_bloc.dart';

/// Класс базового события.
sealed class CardsEvent extends Equatable {
  const CardsEvent();

  @override
  List<Object?> get props => [];
}

/// Класс события получения списка скидочных карточек.
final class CardsFetchEvent extends CardsEvent {
  const CardsFetchEvent();
}
