import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/user_entity.dart';
import '../repository/i_auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

/// Блок управлением состоянием экрана авторизации
final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitialState()) {
    on<AuthStartedEvent>(_onStarted);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthDeleteAccountEvent>(_onDeleteAccount);
    on<_AuthUserChanged>(_onUserChanged);
  }

  /// Репозиторий для выполнения операций авторизации пользователя.
  final IAuthRepository _authRepository;

  /// Подписка на прослушивание состояния авторизации
  StreamSubscription<UserEntity?>? _authSubscription;

  /// Запускает прослушивание изменений состояния авторизации.
  Future<void> _onStarted(
    AuthStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthCheckingState());

    await _authSubscription?.cancel();

    _authSubscription = _authRepository.authStateChanges().listen((user) {
      add(_AuthUserChanged(user));
    });
  }

  /// Выполняет регистрацию нового пользователя.
  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoadingState) return;
    emit(const AuthLoadingState());

    try {
      await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );
    } catch (error) {
      emit(AuthErrorState(message: error.toString()));
    }
  }

  /// Выполняет вход существующего пользователя.
  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoadingState) return;
    emit(const AuthLoadingState());

    try {
      await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
    } catch (error) {
      emit(AuthErrorState(message: error.toString()));
    }
  }

  /// Метод для выхода из профиля
  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();

      emit(const AuthUnauthenticatedState());
    } catch (error) {
      emit(AuthErrorState(message: error.toString()));
    }
  }

  /// Метод для удаления аккаунта
  Future<void> _onDeleteAccount(
    AuthDeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    try {
      await _authRepository.deleteAccount(password: event.password);

      emit(const AuthUnauthenticatedState());
    } catch (error) {
      emit(AuthErrorState(message: error.toString()));
    }
  }

  /// Обрабатывает изменение текущего пользователя, полученное через поток authStateChanges().
  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;

    if (user == null) {
      emit(const AuthUnauthenticatedState());

      return;
    }

    emit(AuthAuthenticatedState(user: user));
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}

/// Внутреннее событие успешного получения пользователя.
final class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);

  /// Пользователь.
  final UserEntity? user;

  @override
  List<Object?> get props => [user];
}
