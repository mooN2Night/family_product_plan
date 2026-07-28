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

  Future<void> initialize() async {
    final familyId = await _repository.getCurrentFamily();

    _emitState(familyId);

    _subscription ??= _repository.watchCurrentFamily().listen(_emitState);

    await _repository.refresh();
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
