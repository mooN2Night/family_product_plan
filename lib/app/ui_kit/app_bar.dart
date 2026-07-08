import 'package:flutter/material.dart';

/// Типы пользовательского AppBar, используемые в приложении.
enum CustomAppBarType {
  /// AppBar главного экрана.
  main,

  /// AppBar экрана профиля.
  profile,

  /// AppBar экрана детальной информации о продукте.
  productDetail,

  /// Авторизация
  login,

  /// Регистрация
  register,
}

/// Пользовательская реализация AppBar.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Базовый конструктор пользовательского AppBar.
  const CustomAppBar._({
    required this.type,
    required this.title,
    this.actions = const [],
    this.bottom,
  });

  /// Создает AppBar для главного экрана.
  factory CustomAppBar.main({
    required PreferredSizeWidget bottom,
    required List<Widget> actions,
  }) {
    return CustomAppBar._(
      type: CustomAppBarType.main,
      bottom: bottom,
      actions: actions,
      title: 'Семья Гавриловых',
    );
  }

  /// Создает AppBar для экрана профиля.
  factory CustomAppBar.profile({required List<Widget> actions}) {
    return CustomAppBar._(
      type: CustomAppBarType.profile,
      actions: actions,
      title: 'Семья Гавриловых',
    );
  }

  /// Создает AppBar для экрана детальной информации о продукте.
  factory CustomAppBar.productDetail({
    required List<Widget> actions,
    required String title,
  }) {
    return CustomAppBar._(
      type: CustomAppBarType.productDetail,
      actions: actions,
      title: title,
    );
  }

  /// Создает AppBar для экрана авторизации.
  factory CustomAppBar.login() {
    return CustomAppBar._(type: CustomAppBarType.login, title: 'Авторизация');
  }

  /// Создает AppBar для экрана регистрации.
  factory CustomAppBar.register() {
    return CustomAppBar._(type: CustomAppBarType.login, title: 'Регистрация');
  }

  /// Виджет, отображаемый в нижней части AppBar.
  final PreferredSizeWidget? bottom;

  /// Набор действий, отображаемых справа в AppBar.
  final List<Widget> actions;

  /// Тип текущей конфигурации AppBar.
  final CustomAppBarType type;

  /// Заголовок AppBar.
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: Colors.blueGrey,
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          bottom: Radius.circular(20),
        ),
        side: BorderSide(color: Colors.black12),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
  // Size.fromHeight(bottom != null ? 90 : 60);
}
