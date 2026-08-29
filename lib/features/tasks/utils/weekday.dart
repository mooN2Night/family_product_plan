enum Weekday {
  monday(1, 'Пн', 'Понедельник'),
  tuesday(2, 'Вт', 'Вторник'),
  wednesday(3, 'Ср', 'Среда'),
  thursday(4, 'Чт', 'Четверг'),
  friday(5, 'Пт', 'Пятница'),
  saturday(6, 'Сб', 'Суббота'),
  sunday(7, 'Вс', 'Воскресенье');

  const Weekday(this.isoValue, this.shortLabel, this.fullLabel);

  final int isoValue;
  final String shortLabel;
  final String fullLabel;

  static Weekday fromDate(DateTime date) =>
      Weekday.values.firstWhere((w) => w.isoValue == date.weekday);

  /// Ближайшая дата (сегодня или позже) с этим днём недели.
  DateTime toNextDate() {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    var diff = isoValue - todayDateOnly.weekday;
    if (diff < 0) diff += 7;

    return todayDateOnly.add(Duration(days: diff));
  }
}
