import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'i_permission_handler.dart';

final class AppPermissionHandler implements IPermissionHandler {
  const AppPermissionHandler();

  @override
  Future<bool> requestPhotosPermission() async {
    if (Platform.isAndroid) {
      return (await Permission.photos.request()).isGranted;
    }

    return (await Permission.photos.request()).isGranted;
  }
}
