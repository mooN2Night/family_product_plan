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
    this.suffixIcon,
    this.onIconPressed,
  });

  /// Сообщение, которое будет отображаться в снекбаре.
  final String message;

  /// Тип снекбара, определяющий его цвет и назначение.
  final SnackBarType type;

  /// Продолжительность отображения снекбара.
  final Duration displayDuration;

  /// Функция, вызываемая при закрытии снекбара.
  final VoidCallback? onDismiss;

  final Icon? suffixIcon;

  final VoidCallback? onIconPressed;

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
    Icon? suffixIcon,
    VoidCallback? onIconPressed,
  }) {
    _show(
      context: context,
      message: message,
      type: .info,
      displayDuration: displayDuration,
      suffixIcon: suffixIcon,
      onIconPressed: onIconPressed,
    );
  }

  static void showSuccess(
    BuildContext context, {
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
    Icon? suffixIcon,
    VoidCallback? onIconPressed,
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
        suffixIcon: suffixIcon,
        onIconPressed: onIconPressed,
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
    with TickerProviderStateMixin {
  /// Контроллер анимации появления и скрытия снекбара.
  late AnimationController _animationController;

  /// Анимация вертикального перемещения снекбара.
  late Animation<double> _slideAnimation;

  // Контроллер для анимации возврата на место после недостаточного свайпа
  late AnimationController _dragReturnController;
  late Animation<Offset> _dragReturnAnimation;

  /// Таймер автоматического закрытия снекбара.
  Timer? _dismissTimer;

  /// Флаг завершения первичной инициализации.
  ///
  /// Используется для предотвращения повторного запуска
  /// анимации и таймера в [didChangeDependencies].
  bool _isInitialized = false;

  /// Текущее смещение от свайпа (в процессе перетаскивания)
  Offset _dragOffset = Offset.zero;

  static const double _horizontalDismissThreshold = 100;
  static const double _verticalDismissThreshold = -80;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dragReturnController =
        AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: this,
        )..addListener(() {
          setState(() => _dragOffset = _dragReturnAnimation.value);
        });
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
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              behavior: HitTestBehavior.opaque,
              child: Transform.translate(
                offset: _dragOffset,
                child: Opacity(
                  // Плавно "растворяем" по мере утягивания в сторону/вверх
                  opacity:
                      (1 -
                              (_dragOffset.dx.abs() / 200).clamp(0.0, 1.0) -
                              (_dragOffset.dy.abs() / 200).clamp(0.0, 1.0))
                          .clamp(0.0, 1.0),
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
                        if (widget.suffixIcon != null)
                          IconButton(
                            onPressed: widget.onIconPressed,
                            icon: widget.suffixIcon!,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animationController.dispose();
    _dragReturnController.dispose();
    super.dispose();
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
  void _startDismissTimer() =>
      _dismissTimer = Timer(widget.displayDuration, _dismiss);

  /// Останавливаем автоматическое закрытие, пока пользователь держит палец —
  /// иначе снекбар может исчезнуть прямо во время свайпа.
  void _pauseDismissTimer() => _dismissTimer?.cancel();

  void _resumeDismissTimer() {
    _dismissTimer?.cancel();
    _startDismissTimer();
  }

  /// Закрытие снекбара.
  void _dismiss() {
    if (!mounted) return;

    _dismissTimer?.cancel();
    unawaited(
      _animationController.reverse().then((_) {
        if (mounted) widget.onDismiss?.call();
      }),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _pauseDismissTimer();
    _dragReturnController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      final newDx = _dragOffset.dx + details.delta.dx;
      // По вертикали разрешаем утягивать только вверх (в минус),
      // вниз тянуть незачем — визуально это будет выглядеть странно
      final newDy = (_dragOffset.dy + details.delta.dy).clamp(-300.0, 0.0);
      _dragOffset = Offset(newDx, newDy);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final draggedEnoughHorizontally =
        _dragOffset.dx.abs() > _horizontalDismissThreshold;
    final draggedEnoughVertically = _dragOffset.dy < _verticalDismissThreshold;

    if (draggedEnoughHorizontally || draggedEnoughVertically) {
      _flingAndDismiss();
    } else {
      _snapBack();
      _resumeDismissTimer();
    }
  }

  /// Доводим движение в ту же сторону, куда тянул пользователь,
  /// чтобы снекбар "улетел" с экрана, а не просто пропал.
  void _flingAndDismiss() {
    _dismissTimer?.cancel();

    final screenWidth = MediaQuery.of(context).size.width;
    final direction = _dragOffset.dx.abs() > _dragOffset.dy.abs()
        ? Offset(_dragOffset.dx.sign * screenWidth, _dragOffset.dy)
        : Offset(_dragOffset.dx, -400);

    _dragReturnAnimation = Tween<Offset>(begin: _dragOffset, end: direction)
        .animate(
          CurvedAnimation(parent: _dragReturnController, curve: Curves.easeIn),
        );

    unawaited(
      _dragReturnController.forward(from: 0).then((_) {
        if (mounted) widget.onDismiss?.call();
      }),
    );
  }

  void _snapBack() {
    _dragReturnAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _dragReturnController, curve: Curves.easeOut),
        );

    unawaited(_dragReturnController.forward(from: 0));
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
