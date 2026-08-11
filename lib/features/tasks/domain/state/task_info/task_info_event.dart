part of 'task_info_bloc.dart';

/// Класс базового события.
sealed class TaskInfoEvent extends Equatable {
  const TaskInfoEvent();

  @override
  List<Object?> get props => [];
}

final class TaskInfoRequestedEvent extends TaskInfoEvent {
  const TaskInfoRequestedEvent({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
