import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:family_product_plan/app/services/database/i_database.dart';
import 'package:family_product_plan/app/services/database/pending_sync_operations_table.dart';
import 'package:family_product_plan/app/services/database/products_table.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Основная база данных приложения.
@DriftDatabase(tables: [Products, PendingSyncOperations])
class AppDatabase extends _$AppDatabase implements IDatabase {
  AppDatabase(this.path) : super(_openConnection(path));

  /// Путь к директории хранения файла базы данных.
  final String path;

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

  @override
  Future<void> insertPendingSyncOperation(
      PendingSyncOperationsCompanion entity,
      ) {
    return into(pendingSyncOperations).insertOnConflictUpdate(entity);
  }

  @override
  Future<void> updatePendingSyncOperation(
      PendingSyncOperation entity,
      ) {
    return update(pendingSyncOperations).replace(entity);
  }

  @override
  Future<void> deletePendingSyncOperationById(String id) {
    return (delete(
      pendingSyncOperations,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<PendingSyncOperation>> getPendingSyncOperations() {
    return select(pendingSyncOperations).get();
  }

  @override
  Stream<List<PendingSyncOperation>> watchPendingSyncOperations() {
    return select(pendingSyncOperations).watch();
  }

  @override
  Future<void> clearPendingSyncOperations() {
    return delete(pendingSyncOperations).go();
  }
}

/// Создает подключение к базе данных.
LazyDatabase _openConnection(String path) {
  return LazyDatabase(() async {
    final file = File(p.join(path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
