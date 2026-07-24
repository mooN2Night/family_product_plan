abstract interface class ICurrentFamilyProvider {
  Future<String?> getCurrentFamilyId();

  Future<void> setCurrentFamilyId(String familyId);

  Future<void> clearCurrentFamilyId();

  Stream<String?> watchCurrentFamilyId();
}
