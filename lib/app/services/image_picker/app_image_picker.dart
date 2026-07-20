import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'i_image_picker.dart';

final class AppImagePickerService implements IImagePicker {
  AppImagePickerService();

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
