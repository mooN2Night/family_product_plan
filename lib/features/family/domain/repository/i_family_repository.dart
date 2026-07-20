import 'package:family_product_plan/features/family/domain/entity/family_entity.dart';

/// Интерфейс репозитория семьи
abstract interface class IFamilyRepository {
  /// Содание семьи
  Future<void> createFamily({required String name});

  /// Получение семьи
  Future<FamilyEntity> getFamily({required String familyId});

  /// Поток обновления семьи
  Stream<FamilyEntity> watchFamily({required String familyId});
}
