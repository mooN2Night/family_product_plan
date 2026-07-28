import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'i_network_service.dart';

class NetworkService implements INetworkService {
  @override
  Future<bool> hasInternet() {
    return InternetConnection().hasInternetAccess;
  }

  @override
  Stream<bool> watchConnection() {
    return InternetConnection().onStatusChange.map(
          (status) => status == InternetStatus.connected,
    );
  }
}