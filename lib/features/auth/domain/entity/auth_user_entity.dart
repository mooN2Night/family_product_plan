import 'package:equatable/equatable.dart';

/// Сущность пользователя
class AuthUserEntity extends Equatable {
  const AuthUserEntity({required this.id, required this.email});

  /// Уникальный идентификатор
  final String id;

  /// Почта
  final String email;

  @override
  List<Object?> get props => [id, email];
}
