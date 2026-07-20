import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:family_product_plan/app/services/database/i_database.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Таблица продуктов.
class Products extends Table {
  /// Уникальный идентификатор продукта. Генерируется автоматически при создании записи.
  IntColumn get id => integer().autoIncrement()();

  /// Наименование продукта.
  TextColumn get name => text()();

  /// Производитель продукта.
  TextColumn get manufacturer => text().withDefault(const Constant('value'))();

  /// Флаг необходимости покупки продукта.
  BoolColumn get isToBuy => boolean().withDefault(const Constant(false))();
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
  Future<int> deleteProductById(int id) =>
      (delete(products)..where((t) => t.id.equals(id))).go();

  @override
  Future<Product> getProductById(int id) =>
      (select(products)..where((product) => product.id.equals(id))).getSingle();
}

/// Создает подключение к базе данных.
LazyDatabase _openConnection(String path) {
  return LazyDatabase(() async {
    final file = File(p.join(path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
