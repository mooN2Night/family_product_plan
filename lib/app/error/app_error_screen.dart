import 'package:flutter/material.dart';

///  Экран, когда в приложении произошла фатальная ошибка
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.error,
    required this.stackTrace,
    super.key,
    this.onRetry,
  });

  /// Объект возникшей ошибки.
  final Object? error;

  /// Стек вызовов, связанный с ошибкой.
  final StackTrace? stackTrace;

  /// Колбэк повторной попытки запуска приложения.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Перезагрузить приложение'),
                ),
                const SizedBox(height: 16),
                Text('''
          Что-то пошло не так, попробуйте перезагрузить приложение
          error: $error
                stackTrace: $stackTrace
                  ''', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
