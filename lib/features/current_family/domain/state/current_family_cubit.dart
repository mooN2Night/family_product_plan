import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/i_current_family_repository.dart';

part 'current_family_state.dart';

final class CurrentFamilyCubit extends Cubit<CurrentFamilyState> {
  CurrentFamilyCubit({required ICurrentFamilyRepository repository})
    : _repository = repository,
      super(const CurrentFamilyLoadingState());

  final ICurrentFamilyRepository _repository;

  StreamSubscription<String?>? _subscription;

  bool _initialized = false;

  Future<void> initialize() async {
    _subscription ??= _repository.watchCurrentFamily().listen(_onFamilyChanged);
    await _repository.refresh();
    _initialized = true;

    final familyId = await _repository.getCurrentFamily();
    _emitState(familyId);
  }

  void _onFamilyChanged(String? familyId) {
    if (!_initialized) return;
    _emitState(familyId);
  }

  void _emitState(String? familyId) {
    if (familyId == null) {
      emit(const CurrentFamilyWithoutFamilyState());
    } else {
      emit(CurrentFamilyWithFamilyState(familyId: familyId));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
