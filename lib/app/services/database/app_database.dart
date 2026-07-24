import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:family_product_plan/app/services/database/i_database.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Таблица продуктов.
class Products extends Table {
  /// Уникальный идентификатор продукта. Генерируется автоматически при создании записи.
  TextColumn get id => text()();

  /// Наименование продукта.
  TextColumn get name => text()();

  /// Производитель продукта.
  TextColumn get manufacturer => text().withDefault(const Constant(''))();

  /// Флаг необходимости покупки продукта.
  BoolColumn get isToBuy => boolean().withDefault(const Constant(false))();

  /// Дата создания.
  DateTimeColumn get createdAt => dateTime()();

  /// Дата последнего обновления.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// Основная база данных приложения.
@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase implements IDatabase {
  AppDatabase(this.path) : super(_openConnection(path));

  /// Путь к директории хранения файла базы данных.
  final String path;

  /// Текущая версия схемы базы данных.
  @override
  int get schemaVersion => 1;

  @override
  Stream<List<Product>> watchAllProducts() => select(products).watch();

  @override
  Future<int> insertProduct(ProductsCompanion entity) =>
      into(products).insert(entity);

  @override
  Future<void> updateProduct(Product entity) =>
      update(products).replace(entity);

  @override
  Future<int> deleteProductById(String id) =>
      (delete(products)..where((t) => t.id.equals(id))).go();

  @override
  Future<Product> getProductById(String id) =>
      (select(products)..where((product) => product.id.equals(id))).getSingle();

  @override
  Future<void> replaceProducts(List<Product> entity) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(products, entity);
    });

    final ids = entity.map((e) => e.id).toSet();

    await (delete(products)..where((tbl) => tbl.id.isNotIn(ids))).go();
  }

  @override
  Future<void> upsertProduct(Product product) {
    return into(products).insertOnConflictUpdate(product);
  }

  @override
  Future<List<Product>> getProducts() {
    return select(products).get();
  }

  @override
  Future<void> clearProducts() {
    return delete(products).go();
  }
}

/// Создает подключение к базе данных.
LazyDatabase _openConnection(String path) {
  return LazyDatabase(() async {
    final file = File(p.join(path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
