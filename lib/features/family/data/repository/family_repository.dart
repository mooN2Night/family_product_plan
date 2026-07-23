import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/family/data/dto/family_dto.dart';
import 'package:family_product_plan/features/family/data/dto/family_member_dto.dart';
import 'package:family_product_plan/features/family/data/dto/family_member_info_dto.dart';
import 'package:family_product_plan/features/family/domain/entity/family_entity.dart';
import 'package:family_product_plan/features/family/domain/entity/family_member_entity.dart';
import 'package:family_product_plan/features/family/domain/entity/family_member_info_entity.dart';
import 'package:family_product_plan/features/family/domain/entity/family_relation.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/utils/family_invite_code_generator.dart';
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
        joinCode: FamilyInviteCodeGenerator.generate(),
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
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) throw AppUnknownException();

      final currentMember = family.members.firstWhere(
        (member) => member.userId == currentUser.uid,
      );

      final canEditRelation = currentMember.role == FamilyRole.owner;

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
          return dto.toEntity(
            role: member.role,
            relation: member.relation,
            canEditRelation: canEditRelation,
            isCurrentUser: member.userId == currentUser.uid,
          );
        }),
      );

      return members;
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> updateMemberRelation({
    required String familyId,
    required String userId,
    required FamilyRelation relation,
  }) async {
    try {
      final family = await getFamily(familyId: familyId);

      final updatedMembers = family.members.map((member) {
        if (member.userId != userId) return member;

        return FamilyMemberEntity(
          userId: member.userId,
          role: member.role,
          relation: relation,
        );
      }).toList();

      await _firestore.collection('families').doc(familyId).update({
        'members': updatedMembers
            .map((member) => member.toDto().toJson())
            .toList(),
      });
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> joinFamily({required String joinCode}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) throw AppUnknownException();

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final familyId = userDoc.data()?['familyId'];

      if (familyId != null) throw UserAlreadyHasFamilyException();

      final query = await _firestore
          .collection('families')
          .where('joinCode', isEqualTo: joinCode)
          .limit(1)
          .get();

      if (query.docs.isEmpty) throw FamilyInviteCodeNotFoundException();

      final familyDoc = query.docs.first;

      final family = FamilyDto.fromJson(
        familyDoc.data(),
      ).toEntity(familyDoc.id);

      final alreadyMember = family.members.any(
        (member) => member.userId == currentUser.uid,
      );

      if (alreadyMember) throw UserAlreadyHasFamilyException();

      final updatedMembers = [
        ...family.members,
        FamilyMemberEntity(
          userId: currentUser.uid,
          role: FamilyRole.member,
          relation: FamilyRelation.undefined,
        ),
      ];

      await _firestore.runTransaction((transaction) async {
        transaction.update(familyDoc.reference, {
          'members': updatedMembers
              .map((updatedMember) => updatedMember.toDto().toJson())
              .toList(),
        });

        transaction.update(userDoc.reference, {'familyId': family.id});
      });
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> leaveFamily({required String familyId}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) throw AppUnknownException();

      final familyRef = _firestore.collection('families').doc(familyId);
      final userRef = _firestore.collection('users').doc(currentUser.uid);

      await _firestore.runTransaction((transaction) async {
        final familySnapshot = await transaction.get(familyRef);

        if (!familySnapshot.exists) throw FamilyNotFoundException();

        final family = FamilyDto.fromJson(
          familySnapshot.data()!,
        ).toEntity(familySnapshot.id);

        final member = family.members.firstWhereOrNull(
          (member) => member.userId == currentUser.uid,
        );

        if (member == null) throw ProfileNotFoundException();

        if (member.role == FamilyRole.owner) {
          throw FamilyOwnerCannotLeaveException();
        }

        final updatedMembers = family.members
            .where((member) => member.userId != currentUser.uid)
            .map((member) => member.toDto().toJson())
            .toList();

        transaction.update(familyRef, {'members': updatedMembers});

        transaction.update(userRef, {'familyId': null});
      });
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> removeMember({
    required String familyId,
    required String memberId,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        throw AppUnknownException();
      }

      final familyRef = _firestore.collection('families').doc(familyId);
      final userRef = _firestore.collection('users').doc(memberId);

      await _firestore.runTransaction((transaction) async {
        final familySnapshot = await transaction.get(familyRef);

        if (!familySnapshot.exists) {
          throw FamilyNotFoundException();
        }

        final family = FamilyDto.fromJson(
          familySnapshot.data()!,
        ).toEntity(familySnapshot.id);

        final currentMember = family.members.firstWhere(
          (member) => member.userId == currentUser.uid,
        );

        if (currentMember.role != FamilyRole.owner) {
          throw const FamilyPermissionDeniedException();
        }

        if (currentUser.uid == memberId) {
          throw const FamilyOwnerCannotLeaveException();
        }

        final updatedMembers = family.members
            .where((member) => member.userId != memberId)
            .map((member) => member.toDto().toJson())
            .toList();

        transaction.update(familyRef, {'members': updatedMembers});

        transaction.update(userRef, {'familyId': null});
      });
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> deleteFamily({required String familyId}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) throw AppUnknownException();

      final familyRef = _firestore.collection('families').doc(familyId);

      await _firestore.runTransaction((transaction) async {
        final familySnapshot = await transaction.get(familyRef);

        if (!familySnapshot.exists) throw FamilyNotFoundException();

        final family = FamilyDto.fromJson(
          familySnapshot.data()!,
        ).toEntity(familySnapshot.id);

        final currentMember = family.members.firstWhere(
              (member) => member.userId == currentUser.uid,
        );

        if (currentMember.role != FamilyRole.owner) {
          throw FamilyPermissionDeniedException();
        }

        for (final member in family.members) {
          final userRef = _firestore
              .collection('users')
              .doc(member.userId);

          transaction.update(userRef, {
            'familyId': null,
          });
        }

        transaction.delete(familyRef);
      });
    } on Object catch (error) {
      throw FamilyExceptionMapper.fromException(error);
    }
  }
}
