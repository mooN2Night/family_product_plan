import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'i_image_picker.dart';

/// Реализация сервиса выбора изображения из галереи телефона.
final class AppImagePickerService implements IImagePicker {
  AppImagePickerService();

  /// Севис выбора фото
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickFromGallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return null;

    return File(image.path);
  }
}
