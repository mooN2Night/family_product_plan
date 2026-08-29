import 'dart:async';

import 'package:flutter/material.dart';

import 'i_day_change_notifier.dart';

final class DayChangeNotifier
    with WidgetsBindingObserver
    implements IDayChangeNotifier {
  DayChangeNotifier() {
    WidgetsBinding.instance.addObserver(this);
    _scheduleTimer();
  }

  final _controller = StreamController<void>.broadcast();

  Timer? _timer;
  DateTime _currentDate = _dateOnly(DateTime.now());

  @override
  Stream<void> get onDayChanged => _controller.stream;

  void _scheduleTimer() {
    _timer?.cancel();

    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);

    _timer = Timer(nextDay.difference(now), _handleDayChange);
  }

  void _handleDayChange() {
    _currentDate = _dateOnly(DateTime.now());
    _controller.add(null);
    _scheduleTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    final currentDate = _dateOnly(DateTime.now());
    if (currentDate != _currentDate) {
      _handleDayChange();
    } else {
      _scheduleTimer();
    }
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _controller.close();
  }
}
