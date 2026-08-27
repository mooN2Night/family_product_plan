import 'package:drift/drift.dart';

class PendingSyncOperations extends Table {
  /// Уникальный идентификатор операции.
  TextColumn get id => text()();

  /// Тип операции.
  TextColumn get operation => text()();

  /// Тип операции.
  TextColumn get entityType => text()();

  /// Идентификатор продукта.
  TextColumn get entityId => text()();

  /// Json продукта.
  TextColumn get payload => text().nullable()();

  /// Время создания операции.
  DateTimeColumn get createdAt => dateTime()();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
