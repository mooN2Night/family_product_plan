import 'dart:async';

import 'i_current_family_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class CurrentFamilyProvider implements ICurrentFamilyProvider {
  CurrentFamilyProvider({required FlutterSecureStorage storage})
    : _storage = storage {
    _init();
  }

  final FlutterSecureStorage _storage;

  final _controller = StreamController<String?>.broadcast();

  static const _key = 'current_family_id';

  @override
  Future<String?> getCurrentFamilyId() {
    return _storage.read(key: _key);
  }

  @override
  Future<void> setCurrentFamilyId(String? id) async {
    if (id == null) {
      await _storage.delete(key: _key);
    } else {
      await _storage.write(key: _key, value: id);
    }

    _controller.add(id);
  }

  @override
  Future<void> clearCurrentFamilyId() async {
    await _storage.delete(key: _key);
    _controller.add(null);
  }

  @override
  Stream<String?> watchCurrentFamilyId() => _controller.stream;

  Future<void> _init() async {
    _controller.add(await getCurrentFamilyId());
  }

  void dispose() {
    _controller.close();
  }
}
