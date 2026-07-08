import 'dart:async';

import 'package:family_product_plan/features/auth/domain/state/auth_bloc.dart';
import 'package:flutter/material.dart';

/// Обновляет состояние GoRouter при изменении авторизации.
///
/// GoRouter использует Listenable для повторного вызова redirect.
/// Этот класс связывает AuthBloc и систему навигации.
final class AuthRefreshListener extends ChangeNotifier {
  AuthRefreshListener({required AuthBloc authBloc}) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  /// Подписка на изменения состояния AuthBloc.
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
