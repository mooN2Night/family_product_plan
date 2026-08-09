import 'package:drift/drift.dart';

/// Таблица задач
class Tasks extends Table {
  /// Уникальный идентификатор.
  TextColumn get id => text()();

  /// Название задачи.
  TextColumn get title => text()();

  /// Описание задачи.
  TextColumn get description => text().nullable()();

  /// Тип задачи.
  TextColumn get type => text()();

  /// Приоритет задачи.
  TextColumn get priority => text()();

  /// Порядок отображения.
  IntColumn get sortOrder => integer()();

  /// Дата создания.
  DateTimeColumn get createdAt => dateTime()();

  /// Дата последнего изменения.
  DateTimeColumn get updatedAt => dateTime()();

  /// Срок выполнения.
  DateTimeColumn get dueDate => dateTime().nullable()();

  /// Дата завершения.
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Дата последнего выполнения.
  DateTimeColumn get lastExecutionAt => dateTime().nullable()();

  /// Дата следующего выполнения.
  DateTimeColumn get nextExecutionAt => dateTime().nullable()();

  /// Статус выполнения.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// Tombstone-флаг.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// Идентификатор назначенного пользователя.
  TextColumn get assignedUserId => text().nullable()();

  /// Идентификатор создателя.
  TextColumn get createdBy => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  List<Set<Column<Object>>> get indexes => [
    {isDeleted},
    {priority, sortOrder},
    {nextExecutionAt},
  ];
}
