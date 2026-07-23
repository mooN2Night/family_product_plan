import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';
import '../../../utils/family_member_action.dart';

part 'family_remove_member_event.dart';

part 'family_remove_member_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyRemoveMemberBloc
    extends Bloc<FamilyRemoveMemberEvent, FamilyRemoveMemberState> {
  FamilyRemoveMemberBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyRemoveMemberInitialState()) {
    on<FamilyRemoveMemberYourselfEvent>(_leaveFamily);
    on<FamilyRemoveMemberOtherEvent>(_removeMember);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Метод для создания семьи.
  Future<void> _leaveFamily(
    FamilyRemoveMemberYourselfEvent event,
    Emitter<FamilyRemoveMemberState> emit,
  ) async {
    if (state is FamilyRemoveMemberLoadingState) return;
    emit(const FamilyRemoveMemberLoadingState());

    try {
      await _familyRepository.leaveFamily(familyId: event.familyId);

      emit(FamilyRemoveMemberSuccessState(action: FamilyMemberAction.leave));
    } on AppException catch (error, stackTrace) {
      emit(FamilyRemoveMemberErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  Future<void> _removeMember(
    FamilyRemoveMemberOtherEvent event,
    Emitter<FamilyRemoveMemberState> emit,
  ) async {
    if (state is FamilyRemoveMemberLoadingState) return;

    emit(const FamilyRemoveMemberLoadingState());

    try {
      await _familyRepository.removeMember(
        familyId: event.familyId,
        memberId: event.userId,
      );

      emit(
        const FamilyRemoveMemberSuccessState(action: FamilyMemberAction.remove),
      );
    } on AppException catch (error, stackTrace) {
      emit(FamilyRemoveMemberErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
