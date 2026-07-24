import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:family_product_plan/features/profile/domain/repository/i_profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';
import '../../entity/family_relation.dart';

part 'family_member_info_event.dart';

part 'family_member_info_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyMemberInfoBloc
    extends Bloc<FamilyMemberInfoEvent, FamilyMemberInfoState> {
  FamilyMemberInfoBloc({
    required IFamilyRepository familyRepository,
    required IProfileRepository profileRepository,
  }) : _familyRepository = familyRepository,
       _profileRepository = profileRepository,
       super(const FamilyMemberInfoInitialState()) {
    on<FamilyMemberInfoLoadEvent>(_load);
    on<FamilyMemberInfoUpdateRelationEvent>(_updateRelation);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Репозиторий профиля
  final IProfileRepository _profileRepository;

  Future<void> _load(
    FamilyMemberInfoLoadEvent event,
    Emitter<FamilyMemberInfoState> emit,
  ) async {
    if (state is FamilyMemberInfoLoadingState) return;
    emit(const FamilyMemberInfoLoadingState());

    try {
      final profile = await _profileRepository.getProfileById(
        userId: event.userId,
      );

      emit(FamilyMemberInfoLoadedState(profile: profile));
    } on AppException catch (error, stackTrace) {
      emit(FamilyMemberInfoErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  Future<void> _updateRelation(
    FamilyMemberInfoUpdateRelationEvent event,
    Emitter<FamilyMemberInfoState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FamilyMemberInfoLoadedState) return;

    try {
      await _familyRepository.updateMemberRelation(
        familyId: event.familyId,
        userId: event.userId,
        relation: event.relation,
      );

      emit(currentState.copyWith(relation: event.relation));
    } on AppException catch (error, stackTrace) {
      emit(FamilyMemberInfoErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
