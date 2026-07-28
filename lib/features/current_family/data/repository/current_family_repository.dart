import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/services/family/i_current_family_provider.dart';
import '../../domain/repository/i_current_family_repository.dart';

final class CurrentFamilyRepository implements ICurrentFamilyRepository {
  const CurrentFamilyRepository({
    required ICurrentFamilyProvider provider,
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _provider = provider,
       _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  final ICurrentFamilyProvider _provider;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<String?> getCurrentFamily() {
    return _provider.getCurrentFamilyId();
  }

  @override
  Stream<String?> watchCurrentFamily() {
    return _provider.watchCurrentFamilyId();
  }

  @override
  Future<void> refresh() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      await _provider.clearCurrentFamilyId();
      return;
    }

    try {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();

      final familyId = snapshot.data()?['familyId'] as String?;

      await _provider.setCurrentFamilyId(familyId);
    } on Exception {
      // Нет интернета.
      // Просто оставляем локальное значение.
    }
  }

  @override
  Future<void> setCurrentFamily(String? familyId) {
    return _provider.setCurrentFamilyId(familyId);
  }

  @override
  Future<void> clear() {
    return _provider.clearCurrentFamilyId();
  }
}
