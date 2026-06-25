import 'dart:async';

import 'package:flutter/material.dart';

import 'app_box.dart';

/// Перечисление для типов снекбаров.
enum SnackBarType {
  /// Снекбар с успехом.
  success,

  /// Снекбар с ошибкой.
  error,

  /// Снекбар с информацией.
  info,
}

/// Пользовательский снекбар приложения.
class AppSnackBar extends StatefulWidget {
  const AppSnackBar._({
    required this.message,
    required this.type,
    required this.displayDuration,
    this.onDismiss,
  });

  /// Сообщение, которое будет отображаться в снекбаре.
  final String message;

  /// Тип снекбара, определяющий его цвет и назначение.
  final SnackBarType type;

  /// Продолжительность отображения снекбара.
  final Duration displayDuration;

  /// Функция, вызываемая при закрытии снекбара.
  final VoidCallback? onDismiss;

  @override
  State<AppSnackBar> createState() => _AppSnackBarState();

  static void showError(
    BuildContext context, {
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message,
      type: .error,
      displayDuration: displayDuration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message,
      type: .info,
      displayDuration: displayDuration,
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message,
      type: .success,
      displayDuration: displayDuration,
    );
  }

  /// Приватный метод для показа снекбара.
  static void _show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    required Duration displayDuration,
  }) {
    // Удаляем предыдущий снекбар
    _removeCurrentSnackBar();

    if (!context.mounted) return;

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => AppSnackBar._(
        message: message,
        type: type,
        displayDuration: displayDuration,
        onDismiss: _removeCurrentSnackBar,
      ),
    );

    _currentSnackBar = overlayEntry;
    overlay.insert(overlayEntry);
  }

  /// Текущий отображаемый снекбар.
  ///
  /// Используется для предотвращения одновременного отображения
  /// нескольких снекбаров.
  static OverlayEntry? _currentSnackBar;

  /// Приватный метод для удаления снекбара.
  static void _removeCurrentSnackBar() {
    _currentSnackBar?.remove();
    _currentSnackBar = null;
  }
}

class _AppSnackBarState extends State<AppSnackBar>
    with SingleTickerProviderStateMixin {
  /// Контроллер анимации появления и скрытия снекбара.
  late AnimationController _animationController;

  /// Анимация вертикального перемещения снекбара.
  late Animation<double> _slideAnimation;

  /// Таймер автоматического закрытия снекбара.
  Timer? _dismissTimer;

  /// Флаг завершения первичной инициализации.
  ///
  /// Используется для предотвращения повторного запуска
  /// анимации и таймера в [didChangeDependencies].
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initAnimation();
      _startDismissTimer();
      _isInitialized = true;
    }
  }

  /// Инициализация анимации для снекбара.
  /// Используется для определения начальной и конечной позиции снекбара.
  /// Начальная позиция - за пределами экрана, конечная - 15 пикселей ниже верхнего отступа.
  void _initAnimation() {
    final topPadding = MediaQuery.of(context).padding.top;
    // Начальная позиция снекбара - за пределами экрана
    final startPosition = -200.0;
    // Конечная позиция снекбара - 15 пикселей ниже верхнего отступа
    final endPosition = topPadding + 15;
    // Создание анимации с использованием Tween
    _slideAnimation = Tween<double>(begin: startPosition, end: endPosition)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    unawaited(_animationController.forward());
  }

  /// Запуск таймера для автоматического закрытия снекбара.
  void _startDismissTimer() {
    _dismissTimer = Timer(widget.displayDuration, _dismiss);
  }

  /// Закрытие снекбара.
  void _dismiss() {
    if (!mounted) return;

    _dismissTimer?.cancel();
    unawaited(
      _animationController.reverse().then((_) {
        if (mounted) {
          widget.onDismiss?.call();
        }
      }),
    );
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Positioned(
          left: 0,
          right: 0,
          top: _slideAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              behavior: HitTestBehavior.opaque,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 350),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(widget.type),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    _Icon(type: widget.type),
                    const WBox(10),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Получение цвета фона снекбара в зависимости от его типа.
  Color _getBackgroundColor(SnackBarType type) {
    return switch (type) {
      .success => Colors.green,
      .error => Colors.red,
      .info => Colors.grey,
    };
  }
}

/// Виджет для отображения иконки в снекбаре.
class _Icon extends StatelessWidget {
  const _Icon({required this.type});

  /// Тип снекбара, определяющий иконку.
  final SnackBarType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      .success => const Icon(Icons.check_circle, color: Colors.white, size: 32),
      .error => const Icon(Icons.error, color: Colors.white, size: 32),
      .info => const Icon(Icons.info, color: Colors.white, size: 32),
    };
  }
}
