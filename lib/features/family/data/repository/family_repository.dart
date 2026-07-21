import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/family/data/dto/family_dto.dart';
import 'package:family_product_plan/features/family/data/dto/family_member_dto.dart';
import 'package:family_product_plan/features/family/data/dto/family_member_info_dto.dart';
import 'package:family_product_plan/features/family/domain/entity/family_entity.dart';
import 'package:family_product_plan/features/family/domain/entity/family_member_info_entity.dart';
import 'package:family_product_plan/features/family/domain/entity/family_relation.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/family_exception.dart';
import '../../domain/entity/family_role.dart';
import '../../domain/repository/i_family_repository.dart';
import '../mapper/family_exception_mapper.dart';

/// Реализация репозитория для фичи семья.
final class FamilyRepository implements IFamilyRepository {
  const FamilyRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  /// Сервис удаленной бд.
  final FirebaseFirestore _firestore;

  /// Сервис авторизации
  final FirebaseAuth _firebaseAuth;

  @override
  Future<String> createFamily({required String name}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) throw AppUnknownException();

      final familyRef = _firestore.collection('families').doc();

      final family = FamilyDto(
        name: name,
        members: [
          FamilyMemberDto(
            userId: currentUser.uid,
            role: FamilyRole.owner.toString(),
            relation: FamilyRelation.undefined.toString(),
          ),
        ],
        createdAt: DateTime.now(),
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final familyId = userDoc.data()?['familyId'];

      if (familyId != null) {
        throw UserAlreadyHasFamilyException();
      }

      await _firestore.runTransaction((transaction) async {
        transaction.set(familyRef, family.toJson());

        transaction.update(
          _firestore.collection('users').doc(currentUser.uid),
          {'familyId': familyRef.id},
        );
      });

      return familyRef.id;
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Future<FamilyEntity> getFamily({required String familyId}) async {
    try {
      final document = await _firestore
          .collection('families')
          .doc(familyId)
          .get();

      if (!document.exists) throw FamilyNotFoundException();

      return FamilyDto.fromJson(document.data()!).toEntity(document.id);
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Stream<FamilyEntity> watchFamily({required String familyId}) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) {
            throw FamilyNotFoundException();
          }

          return FamilyDto.fromJson(snapshot.data()!).toEntity(snapshot.id);
        })
        .handleError(
          (error) => throw FamilyExceptionMapper.fromException(error),
        );
  }

  @override
  Future<List<FamilyMemberInfoEntity>> getFamilyMembersInfo({
    required FamilyEntity family,
  }) async {
    try {
      final members = await Future.wait(
        family.members.map((member) async {
          final snapshot = await _firestore
              .collection('users')
              .doc(member.userId)
              .get();

          if (!snapshot.exists) throw ProfileNotFoundException();

          final dto = FamilyMemberInfoDto.fromJson(
            snapshot.id,
            snapshot.data()!,
          );
          return dto.toEntity(role: member.role, relation: member.relation);
        }),
      );

      return members;
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }
}
