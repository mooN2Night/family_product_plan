import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';
import '../../../../home/domain/repository/i_home_repository.dart';

part 'family_join_event.dart';

part 'family_join_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyJoinBloc extends Bloc<FamilyJoinEvent, FamilyJoinState> {
  FamilyJoinBloc({
    required IFamilyRepository familyRepository,
    required IHomeRepository homeRepository,
  }) : _familyRepository = familyRepository,
       _homeRepository = homeRepository,
       super(const FamilyJoinInitialState()) {
    on<FamilyJoinRequestedEvent>(_joinFamily);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Репозиторий главного экрана
  final IHomeRepository _homeRepository;

  Future<void> _joinFamily(
    FamilyJoinRequestedEvent event,
    Emitter<FamilyJoinState> emit,
  ) async {
    if (state is FamilyJoinLoadingState) return;
    emit(const FamilyJoinLoadingState());

    try {
      await _familyRepository.joinFamily(joinCode: event.joinCode);
      await _homeRepository.clearLocalProducts();

      emit(const FamilyJoinSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(FamilyJoinErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
