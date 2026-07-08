import 'package:equatable/equatable.dart';

/// Сущность пользователя
class UserEntity extends Equatable {
  const UserEntity({required this.id, required this.email});

  /// Уникальный идентификатор
  final String id;

  /// Почта
  final String email;

  @override
  List<Object?> get props => [id, email];
}
