import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'i_permission_handler.dart';

/// Реализация сервиса запроса доступов.
final class AppPermissionHandler implements IPermissionHandler {
  const AppPermissionHandler();

  @override
  Future<bool> requestPhotosPermission() async {
    if (Platform.isAndroid) {
      return (await Permission.photos.request()).isGranted;
    }

    return (await Permission.photos.request()).isGranted;
  }

  @override
  Future<AppPermissionResult> requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) return AppPermissionResult.granted;
    if (status.isPermanentlyDenied) return AppPermissionResult.permanentlyDenied;

    return AppPermissionResult.denied;
  }

  @override
  Future<bool> openSettings() => openAppSettings();
}
