import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/error/app_exception.dart';
import '../../entity/family_member_info_entity.dart';

part 'family_fetch_member_event.dart';

part 'family_fetch_member_state.dart';

/// Блок управлением состоянием экрана информации об участнике семьи
final class FamilyFetchMemberBloc
    extends Bloc<FamilyFetchMemberEvent, FamilyFetchMemberState> {
  FamilyFetchMemberBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyFetchMemberInitialState()) {
    on<FamilyFetchMemberLoadEvent>(_load);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Метод получения профиля пользователя семьи
  Future<void> _load(
    FamilyFetchMemberLoadEvent event,
    Emitter<FamilyFetchMemberState> emit,
  ) async {
    if (state is FamilyFetchMemberLoadingState) return;
    emit(const FamilyFetchMemberLoadingState());

    try {
      final members = await _familyRepository.getFamilyMembersInfoByFamilyId(
        familyId: event.familyId,
      );

      emit(FamilyFetchMemberLoadedState(members: members));
    } on AppException catch (error, stackTrace) {
      emit(FamilyFetchMemberErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
