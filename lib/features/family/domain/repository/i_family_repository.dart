import 'package:family_product_plan/features/family/domain/entity/family_entity.dart';

import '../entity/family_member_info_entity.dart';
import '../entity/family_relation.dart';

/// Интерфейс репозитория семьи
abstract interface class IFamilyRepository {
  /// Содание семьи
  Future<String> createFamily({required String name});

  /// Получение семьи
  Future<FamilyEntity> getFamily({required String familyId});

  /// Поток обновления семьи
  Stream<FamilyEntity> watchFamily({required String familyId});

  /// Получения списка участников в семье.
  Future<List<FamilyMemberInfoEntity>> getFamilyMembersInfo({
    required FamilyEntity family,
  });

  /// Изменение родственной связи участника семьи.
  Future<void> updateMemberRelation({
    required String familyId,
    required String userId,
    required FamilyRelation relation,
  });

  /// Присоединиться к семье по коду.
  Future<void> joinFamily({required String joinCode});
}
