import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';

part 'family_delete_event.dart';

part 'family_delete_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyDeleteBloc
    extends Bloc<FamilyDeleteEvent, FamilyDeleteState> {
  FamilyDeleteBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyDeleteInitialState()) {
    on<FamilyDeleteRequestedEvent>(_deleteFamily);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Метод для создания семьи.
  Future<void> _deleteFamily(
    FamilyDeleteRequestedEvent event,
    Emitter<FamilyDeleteState> emit,
  ) async {
    if (state is FamilyDeleteLoadingState) return;
    emit(const FamilyDeleteLoadingState());

    try {
      await _familyRepository.deleteFamily(familyId: event.familyId);

      emit(FamilyDeleteSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(FamilyDeleteErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
