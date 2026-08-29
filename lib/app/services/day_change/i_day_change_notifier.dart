abstract interface class IDayChangeNotifier {
  /// Эмитит событие при смене календарного дня.
  Stream<void> get onDayChanged;

  void dispose();
}