import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/i_profile_repository.dart';

part 'profile_load_event.dart';

part 'profile_load_state.dart';

/// Блок управлением состоянием экрана профиля
final class ProfileLoadBloc extends Bloc<ProfileLoadEvent, ProfileLoadState> {
  ProfileLoadBloc({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileLoadInitialState()) {
    on<ProfileLoadRequestEvent>(_onLoad);
  }

  /// Репозиторий профиля
  final IProfileRepository _profileRepository;

  /// Метод для получения профиля.
  Future<void> _onLoad(
    ProfileLoadRequestEvent event,
    Emitter<ProfileLoadState> emit,
  ) async {
    if (state is ProfileLoadLoadingState) return;
    emit(ProfileLoadLoadingState());

    try {
      final user = await _profileRepository.getProfile();
      emit(ProfileLoadSuccessState(user: user));
    } on AppException catch (error, stackTrace) {
      emit(ProfileLoadErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
