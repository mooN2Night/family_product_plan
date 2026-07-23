import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';

part 'family_create_event.dart';

part 'family_create_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyCreateBloc
    extends Bloc<FamilyCreateEvent, FamilyCreateState> {
  FamilyCreateBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyCreateInitialState()) {
    on<FamilyCreateRequestedEvent>(_createFamily);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Метод для создания семьи.
  Future<void> _createFamily(
    FamilyCreateRequestedEvent event,
    Emitter<FamilyCreateState> emit,
  ) async {
    if (state is FamilyCreateLoadingState) return;
    emit(const FamilyCreateLoadingState());

    try {
      final familyId = await _familyRepository.createFamily(name: event.name);

      emit(FamilyCreateSuccessState(familyId: familyId));
    } on AppException catch (error, stackTrace) {
      emit(FamilyCreateErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
