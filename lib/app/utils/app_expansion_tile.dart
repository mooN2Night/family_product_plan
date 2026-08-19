import 'package:flutter/material.dart';

import '../presentation/ui_kit/app_box.dart';

/// Класс для реализации виджета, отвечающего за отображение открывающейся панели и контента
class AppExpansionWrapper extends StatefulWidget {
  const AppExpansionWrapper._({
    required this.title,
    required this.expandedContent,
    required this.subtitle,
    required this.onOpened,
    required this.onClosed,
    required this.isEnabled,
    required this.decoration,
    required this.padding,
    required this.titleTextStyle,
    required this.iconColor,
  });

  /// Создает виджета, отвечающего за отображение открывающейся панели и контента с границами
  factory AppExpansionWrapper.bordered(
    BuildContext context, {
    required String title,
    required Widget expandedContent,
    String? subtitle,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    bool isEnabled = true,
  }) {
    return AppExpansionWrapper._(
      title: title,
      expandedContent: expandedContent,
      subtitle: subtitle,
      onOpened: onOpened,
      onClosed: onClosed,
      isEnabled: isEnabled,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 11.0),
      titleTextStyle: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
      iconColor: isEnabled ? Colors.black : Colors.grey,
    );
  }

  /// Создает виджета, отвечающего за отображение открывающейся панели и контента без границ
  factory AppExpansionWrapper.borderless(
    BuildContext context, {
    required String title,
    required Widget expandedContent,
    String? subtitle,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    bool isEnabled = true,
  }) {
    return AppExpansionWrapper._(
      title: title,
      expandedContent: expandedContent,
      subtitle: subtitle,
      onOpened: onOpened,
      onClosed: onClosed,
      isEnabled: isEnabled,
      decoration: null,
      padding: EdgeInsets.zero,
      titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
        color: isEnabled ? Colors.black : Colors.grey,
      ),
      iconColor: isEnabled ? Colors.black : Colors.grey,
    );
  }

  /// Заголовок панели
  final String title;

  /// Подзаголовок панели
  final String? subtitle;

  /// Контент, который открывается
  final Widget expandedContent;

  /// Callback-функция, вызываемая при открытии панели
  final VoidCallback? onOpened;

  /// Callback-функция, вызываемая при закрытии панели
  final VoidCallback? onClosed;

  /// Флаг, показывающий, активна ли данная панель
  final bool isEnabled;

  /// Рамка
  final BoxDecoration? decoration;

  /// Отступы
  final EdgeInsets padding;

  /// Стиль заголовка панели
  final TextStyle titleTextStyle;

  /// Цвет иконки
  final Color iconColor;

  @override
  State<AppExpansionWrapper> createState() => _AppExpansionWrapperState();
}

class _AppExpansionWrapperState extends State<AppExpansionWrapper> {
  /// [ValueNotifier], который открывает выпадающее меню
  late final ValueNotifier<bool> _isOpenedNotifier;

  @override
  void initState() {
    super.initState();
    _isOpenedNotifier = ValueNotifier<bool>(false)
      ..addListener(_handleOpen)
      ..addListener(_handleClosed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AppExpansionTile(
          title: widget.title,
          subtitle: widget.subtitle,
          isOpenedNotifier: _isOpenedNotifier,
          isEnabled: widget.isEnabled,
          decoration: widget.decoration,
          padding: widget.padding,
          titleTextStyle: widget.titleTextStyle,
          iconColor: widget.iconColor,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isOpenedNotifier,
          builder: (context, isOpened, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  SizeTransition(sizeFactor: animation, child: child),
              child: isOpened
                  ? widget.expandedContent
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _isOpenedNotifier
      ..removeListener(_handleOpen)
      ..removeListener(_handleClosed)
      ..dispose();
    super.dispose();
  }

  /// Метод для вызова обратной функции в случае открытия панели
  void _handleOpen() {
    if (_isOpenedNotifier.value) widget.onOpened?.call();
  }

  /// Метод для вызова обратной функции в случае закрытия панели
  void _handleClosed() {
    if (!_isOpenedNotifier.value) widget.onClosed?.call();
  }
}

/// Класс для реализации виджета, отвечающего за отображение открывающейся панели
class _AppExpansionTile extends StatelessWidget {
  const _AppExpansionTile({
    required this.title,
    required this.isOpenedNotifier,
    required this.isEnabled,
    required this.decoration,
    required this.padding,
    required this.titleTextStyle,
    required this.iconColor,
    this.subtitle,
  });

  /// Заголовок панели
  final String title;

  /// Подзаголовок панели
  final String? subtitle;

  /// [ValueNotifier], который открывает выпадающее меню
  final ValueNotifier<bool> isOpenedNotifier;

  /// Флаг, показывающий, активна ли данная панель
  final bool isEnabled;

  /// Рамка
  final BoxDecoration? decoration;

  /// Отступы
  final EdgeInsets padding;

  /// Стиль заголовка панели
  final TextStyle titleTextStyle;

  /// Цвет иконки
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? () => isOpenedNotifier.value = !isOpenedNotifier.value
          : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: padding,
        decoration: decoration,
        child: ValueListenableBuilder<bool>(
          valueListenable: isOpenedNotifier,
          builder: (context, isOpened, _) {
            return Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleTextStyle,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const WBox(8),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: isEnabled ? Colors.black : Colors.grey,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                const WBox(8),
                AnimatedRotation(
                  turns: isOpened ? 0.25 : -0.25,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: iconColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
