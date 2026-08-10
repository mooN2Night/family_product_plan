import 'package:flutter/material.dart';

import 'extensions.dart';
import 'task_priority.dart';

class PriorityCheckbox extends StatefulWidget {
  const PriorityCheckbox({
    required this.priority,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TaskPriority priority;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<PriorityCheckbox> createState() => _PriorityCheckboxState();
}

class _PriorityCheckboxState extends State<PriorityCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.82,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await _controller.forward();
    await _controller.reverse();

    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.priority.color;

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.value ? color : Colors.transparent,
                border: Border.all(color: color, width: 2),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: widget.value
                    ? const Icon(
                        Icons.check,
                        key: ValueKey('checked'),
                        size: 16,
                        color: Colors.white,
                      )
                    : const SizedBox(key: ValueKey('unchecked')),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
