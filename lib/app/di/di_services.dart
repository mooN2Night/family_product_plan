import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/app/services/image_picker/i_image_picker.dart';
import 'package:family_product_plan/app/services/permission_hendler/app_permission_handler.dart';
import 'package:family_product_plan/app/services/permission_hendler/i_permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/database/app_database.dart';
import '../services/database/i_database.dart';
import '../services/image_picker/app_image_picker.dart';
import '../services/path_provider/i_path_provider.dart';
import '../services/path_provider/app_path_provider.dart';

/// Контейнер сервисов приложения.
final class DiServices {
  /// Сервис для получения путей к директориям приложения.
  late final IPathProvider pathProvider;

  /// Экземпляр локальной базы данных приложения.
  late final IDatabase database;

  /// Сервис для выбора фотографии.
  late final IImagePicker imagePicker;

  /// Сервис для получения жоступа к функциям телефона.
  late final IPermissionHandler permissionHandler;

  /// Сервис авторизации.
  late final FirebaseAuth firebaseAuth;

  /// Сервис удаленной базы данных приложения.
  late final FirebaseFirestore firestore;

  // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
  // late final FirebaseStorage storage;

  /// Инициализирует сервисы приложения.
  Future<void> init() async {
    pathProvider = AppPathProvider();

    final path = await pathProvider.getAppDocumentsDirectoryPath();
    database = AppDatabase(path);

    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    // storage = FirebaseStorage.instance;

    imagePicker = AppImagePickerService();

    permissionHandler = AppPermissionHandler();
  }
}
