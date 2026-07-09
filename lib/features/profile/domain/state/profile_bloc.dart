import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/i_profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

/// Блок управлением состоянием экрана профиля
final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileInitialState()) {
    on<ProfileWatchEvent>(_onWatch);
    on<ProfileUpdateEvent>(_onUpdate);
    on<_ProfileChangedEvent>(_onChanged);
  }

  /// Репозиторий профиля
  final IProfileRepository _profileRepository;

  /// Подписка на прослушивание состояния профиля
  StreamSubscription<ProfileUserEntity?>? _profileSubscription;

  Future<void> _onWatch(
    ProfileWatchEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    await _profileSubscription?.cancel();

    _profileSubscription = _profileRepository.watchProfile().listen(
      (user) => add(_ProfileChangedEvent(user)),
      onError: (error, stackTrace) {
        addError(error, stackTrace);
      },
    );
  }

  Future<void> _onUpdate(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileSuccessState) return;

    emit(ProfileSavingState(user: currentState.user));

    try {
      await _profileRepository.saveProfile(event.user);
    } on AppException catch (error, stackTrace) {
      emit(ProfileErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  Future<void> _onChanged(
    _ProfileChangedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSuccessState(user: event.user));
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}

final class _ProfileChangedEvent extends ProfileEvent {
  const _ProfileChangedEvent(this.user);

  final ProfileUserEntity user;

  @override
  List<Object?> get props => [user];
}
