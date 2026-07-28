abstract interface class INetworkService {
  Future<bool> hasInternet();

  Stream<bool> watchConnection();
}