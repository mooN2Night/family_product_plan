import 'package:drift/drift.dart';

/// Таблица продуктов.
class Products extends Table {
  /// Уникальный идентификатор продукта. Генерируется автоматически при создании записи.
  TextColumn get id => text()();

  /// Наименование продукта.
  TextColumn get name => text()();

  /// Производитель продукта.
  TextColumn get manufacturer => text().withDefault(const Constant(''))();

  /// Количетсво продукта.
  TextColumn get quantity => text().nullable()();

  /// Описание продукта.
  TextColumn get description => text().nullable()();

  /// Флаг необходимости покупки продукта.
  BoolColumn get isToBuy => boolean().withDefault(const Constant(false))();

  /// Дата создания.
  DateTimeColumn get createdAt => dateTime()();

  /// Дата последнего обновления.
  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
