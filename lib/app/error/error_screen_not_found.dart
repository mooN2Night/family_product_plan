import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_routes.dart';
import '../../features/profile/presentation/profile_routes.dart';
import '../ui_kit/app_bottom_navigation_bar.dart';
import '../ui_kit/app_bottom_navigation_button.dart';

/// Класс для реализации виджета отображения страницы ошибки 404
class ErrorScreenNotFound extends StatelessWidget {
  const ErrorScreenNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar.profile(actions: []),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Center(
          child: Column(
            children: [
              Text('Ничего не найдено'),
              HBox(10),
              Text(
                'Не удалось получить данные. Попробуйте вернуться на предыдущую страницу',
              ),
              HBox(30),
              ElevatedButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(HomeRoutes.homeScreenName);
                  }
                },
                child: Text('Вернуться назад'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Align(
        alignment: Alignment.bottomCenter,
        child: _ErrorScreenBottomNavigationBar(),
      ),
    );
  }
}

/// Виджет нижнего навигационного меню для страницы ошибки
class _ErrorScreenBottomNavigationBar extends StatelessWidget {
  const _ErrorScreenBottomNavigationBar();

  /// Список иконок для нижнего навигационного меню
  static const _buttons = [Icons.home, Icons.person];

  /// Список названий для нижнего навигационного меню
  static const _title = ['Главная', 'Профиль'];

  /// Список путей для нижнего навигационного меню
  static const _paths = [
    HomeRoutes.homeScreenName,
    ProfileRoutes.profileScreenName,
  ];

  @override
  Widget build(BuildContext context) {
    return AppBottomNavigationBar(
      navigationButtons: List.generate(_buttons.length, (index) {
        return AppBottomNavigationButton(
          onTap: () => context.go(_paths[index]),
          isSelected: false,
          icon: _buttons[index],
          title: _title[index],
        );
      }),
    );
  }
}
