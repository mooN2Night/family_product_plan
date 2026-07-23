import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/i_profile_repository.dart';

part 'profile_update_event.dart';

part 'profile_update_state.dart';

/// Блок управлением состоянием экрана профиля
final class ProfileUpdateBloc
    extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  ProfileUpdateBloc({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileUpdateInitialState()) {
    on<ProfileUpdateRequestedEvent>(_onUpdate);
  }

  /// Репозиторий профиля
  final IProfileRepository _profileRepository;

  /// Метод для обновления профиля.
  Future<void> _onUpdate(
    ProfileUpdateRequestedEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileUpdateLoadingState) return;

    emit(ProfileUpdateLoadingState());

    try {
      await _profileRepository.saveProfile(event.user);
    } on AppException catch (error, stackTrace) {
      emit(ProfileUpdateErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
