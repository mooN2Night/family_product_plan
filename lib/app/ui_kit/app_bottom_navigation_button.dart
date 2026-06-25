import 'package:flutter/material.dart';

/// Виджет кнопок нижнего навигационного меню.
class AppBottomNavigationButton extends StatelessWidget {
  const AppBottomNavigationButton({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  /// Действие при нажатии на элемент.
  final VoidCallback onTap;

  /// Флаг, является ли элемент активным.
  final bool isSelected;

  /// Иконка элемента.
  final IconData icon;

  /// Название.
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? Colors.lightBlueAccent : Colors.transparent,
        ),
        child: SizedBox(
          // height: 24,
          // width: 24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
