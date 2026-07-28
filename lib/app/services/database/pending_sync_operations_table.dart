import 'package:drift/drift.dart';

class PendingSyncOperations extends Table {
  /// Уникальный идентификатор операции.
  TextColumn get id => text()();

  /// Тип операции.
  TextColumn get operation => text()();

  /// Идентификатор продукта.
  TextColumn get entityId => text()();

  /// Json продукта.
  TextColumn get payload => text().nullable()();

  /// Время создания операции.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}