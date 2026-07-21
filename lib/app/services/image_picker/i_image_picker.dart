import 'dart:io';

/// Интерфейс сервиса выбора изображения из галереи телефона.
abstract interface class IImagePicker {
  /// Метод для выбора фото с телефона.
  Future<File?> pickFromGallery();
}