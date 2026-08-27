import 'package:drift/drift.dart';

/// Таблица скидочных карт.
class Cards extends Table {
  /// Уникальный идентификатор карты. Генерируется автоматически при создании записи.
  TextColumn get id => text()();

  /// Название магазина.
  TextColumn get name => text()();

  /// Номер карты.
  TextColumn get number => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}