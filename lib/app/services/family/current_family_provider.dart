import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'i_current_family_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Реализация [ICurrentFamilyProvider], использующая [FlutterSecureStorage] для
/// хранения идентификатора текущей семьи.
final class CurrentFamilyProvider implements ICurrentFamilyProvider {
  CurrentFamilyProvider({required FlutterSecureStorage storage})
    : _storage = storage;

  /// Безопасное локальное хранилище.
  final FlutterSecureStorage _storage;

  /// Контроллер, уведомляющий подписчиков об изменении текущей семьи.
  final _controller = BehaviorSubject<String?>();

  /// Ключ для хранения идентификатора семьи.
  static const _key = 'current_family_id';

  @override
  Future<String?> getCurrentFamilyId() async {
    final cached = _controller.valueOrNull;
    if (cached != null) {
      return cached;
    }

    final value = await _storage.read(key: _key);
    _controller.add(value);

    return value;
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
  Stream<String?> watchCurrentFamilyId() async* {
    if (!_controller.hasValue) {
      final value = await _storage.read(key: _key);
      _controller.add(value);
    }

    yield* _controller.stream;
  }

  /// Освобождает ресурсы провайдера.
  void dispose() {
    _controller.close();
  }
}
