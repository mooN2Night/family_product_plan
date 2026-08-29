import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';
import '../../entity/family_entity.dart';

part 'family_fetch_event.dart';

part 'family_fetch_state.dart';

/// Блок управлением состоянием экрана создания семьи
final class FamilyFetchBloc extends Bloc<FamilyFetchEvent, FamilyFetchState> {
  FamilyFetchBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyFetchInitialState()) {
    on<FamilyFetchRequestedEvent>(_fetchFamily);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Метод для создания семьи.
  Future<void> _fetchFamily(
    FamilyFetchRequestedEvent event,
    Emitter<FamilyFetchState> emit,
  ) async {
    if (state is FamilyFetchLoadingState) return;
    emit(const FamilyFetchLoadingState());

    try {
      final family = await _familyRepository.getFamily(
        familyId: event.familyId,
      );

      emit(FamilyFetchSuccessState(family: family));
    } on AppException catch (error, stackTrace) {
      emit(FamilyFetchErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
