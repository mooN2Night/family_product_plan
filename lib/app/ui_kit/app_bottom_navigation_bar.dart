import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_bottom_navigation_button.dart';

/// Виджет нижнего навигационного меню.
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({required this.navigationButtons, super.key});

  /// Список навигационных элементов.
  final List<AppBottomNavigationButton> navigationButtons;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          8,
          math.max(0, 8 + mediaQuery.viewPadding.top),
          8,
          math.max(0, 40 - mediaQuery.padding.bottom),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 72,
            width: 288,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: navigationButtons,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}