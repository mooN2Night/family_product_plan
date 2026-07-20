import 'dart:io';

abstract interface class IImagePicker {
  Future<File?> pickFromGallery();
}