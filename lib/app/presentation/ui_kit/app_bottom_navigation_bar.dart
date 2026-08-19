import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'app_bottom_navigation_button.dart';

/// Виджет нижнего навигационного меню.
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.navigationButtons,
    required this.currentIndex,
    super.key,
  });

  /// Список навигационных элементов.
  final List<AppBottomNavigationButton> navigationButtons;
  final int currentIndex;


  static const _barHeight = 72.0;
  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 7.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _horizontalPadding,
          8,
          _horizontalPadding,
          math.max(
            12,
            24 - mediaQuery.padding.bottom,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              height: _barHeight,
              decoration: BoxDecoration(
                color: AppColors.bottomBar.withValues(
                  alpha: 0.78,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.7,
                  ),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  _verticalPadding,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth =
                        constraints.maxWidth / navigationButtons.length;

                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          curve: Curves.easeOutCubic,
                          left: itemWidth * currentIndex,
                          top: 0,
                          width: itemWidth,
                          height: 58,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.bottomBarActive,
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            for (final button in navigationButtons)
                              SizedBox(
                                width: itemWidth,
                                height: 58,
                                child: button,
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
