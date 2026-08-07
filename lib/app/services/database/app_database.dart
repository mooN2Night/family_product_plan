import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:family_product_plan/app/services/database/i_database.dart';
import 'package:family_product_plan/app/services/database/pending_sync_operations_table.dart';
import 'package:family_product_plan/app/services/database/products_table.dart';
import 'package:family_product_plan/app/services/database/tasks_table.dart';
import 'package:path/path.dart' as p;

import '../../../features/tasks/utils/task_priority.dart';

part 'app_database.g.dart';

/// Основная база данных приложения.
@DriftDatabase(tables: [Products, PendingSyncOperations, Tasks])
class AppDatabase extends _$AppDatabase implements IDatabase {
  AppDatabase(this.path) : super(_openConnection(path));

  /// Путь к директории хранения файла базы данных.
  final String path;

  @override
  int get schemaVersion => 1;

  @override
  Stream<List<Product>> watchAllProducts() {
    return (select(
      products,
    )..where((tbl) => tbl.isDeleted.equals(false))).watch();
  }

  @override
  Future<int> insertProduct(ProductsCompanion entity) =>
      into(products).insert(entity);

  @override
  Future<void> updateProduct(Product entity) async {
    await update(products).replace(entity);
  }

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
  Future<void> updatePendingSyncOperation(PendingSyncOperation entity) {
    return update(pendingSyncOperations).replace(entity);
  }

  @override
  Future<void> deletePendingSyncOperationById(String id) {
    return (delete(pendingSyncOperations)..where((t) => t.id.equals(id))).go();
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

  @override
  Future<PendingSyncOperation?> getPendingSyncOperationByEntityId(
    String entityId,
  ) {
    return (select(
      pendingSyncOperations,
    )..where((t) => t.entityId.equals(entityId))).getSingleOrNull();
  }

  @override
  Stream<List<Task>> watchTodayTasks() {
    final now = DateTime.now();

    final start = DateTime(now.year, now.month, now.day);

    final end = start.add(const Duration(days: 1));

    return (select(tasks)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                t.isActive.equals(true) &
                t.nextExecutionAt.isBiggerOrEqualValue(start) &
                t.nextExecutionAt.isSmallerThanValue(end),
          )
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority),
            (t) => OrderingTerm(expression: t.sortOrder),
          ]))
        .watch();
  }

  @override
  Future<List<Task>> getUrgentTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                t.priority.equals(TaskPriority.urgent.name),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  @override
  Future<List<Task>> getHighPriorityTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                t.priority.equals(TaskPriority.high.name),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  @override
  Future<List<Task>> getMediumPriorityTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                t.priority.equals(TaskPriority.medium.name),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  @override
  Future<List<Task>> getLowPriorityTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                t.priority.equals(TaskPriority.low.name),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  @override
  Future<void> insertTask(TasksCompanion entity) async {
    await into(tasks).insert(entity);
  }

  @override
  Future<void> updateTask(Task entity) async {
    await update(tasks).replace(entity);
  }

  @override
  Future<void> upsertTask(Task entity) async {
    await into(tasks).insertOnConflictUpdate(entity);
  }

  @override
  Future<void> replaceTasks(List<Task> entities) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(tasks, entities);
    });

    final ids = entities.map((e) => e.id).toSet();

    await (delete(tasks)..where((t) => t.id.isNotIn(ids))).go();
  }

  @override
  Future<Task> getTaskById(String id) {
    return (select(tasks)..where((t) => t.id.equals(id))).getSingle();
  }

  @override
  Future<void> deleteTask(Task entity) async {
    await updateTask(
      entity.copyWith(
        isDeleted: true,
        isActive: false,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> clearTasks() async {
    await delete(tasks).go();
  }
}

/// Создает подключение к базе данных.
LazyDatabase _openConnection(String path) {
  return LazyDatabase(() async {
    final file = File(p.join(path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
