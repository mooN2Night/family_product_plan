part of 'cards_bloc.dart';

/// Класс базового события.
sealed class CardsEvent extends Equatable {
  const CardsEvent();

  @override
  List<Object?> get props => [];
}

/// Явный запрос загрузки: первое открытие экрана, pull-to-refresh,
/// реакция на успешное добавление/удаление карты.
final class CardsFetchEvent extends CardsEvent {
  const CardsFetchEvent();
}

/// Внутреннее событие — фоновая синхронизация с Firebase нашла изменения.
/// Не показывает лоадер, просто тихо обновляет список.
final class _CardsChangedEvent extends CardsEvent {
  const _CardsChangedEvent();
}
