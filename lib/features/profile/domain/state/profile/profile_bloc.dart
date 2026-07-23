import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/error/app_exception.dart';
import '../../../data/mapper/profile_exception_mapper.dart';
import '../../repository/i_profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

/// Блок управлением состоянием экрана профиля
final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileInitialState()) {
    on<ProfileWatchEvent>(_watchProfile);
    on<ProfileStopWatchEvent>(_stopWatchProfile);
    on<ProfileUpdateEvent>(_updateProfile);
    on<ProfileWatchErrorEvent>(_watchErrorProfile);
    // on<ProfileAvatarChangedEvent>(_onPickAvatar);
  }

  /// Репозиторий профиля
  final IProfileRepository _profileRepository;

  /// Подписка на прослушивание состояния профиля
  StreamSubscription<ProfileUserEntity?>? _profileSubscription;

  /// Метод для отслеживания состояния профиля.
  Future<void> _watchProfile(
    ProfileWatchEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoadingState());

    await _profileSubscription?.cancel();

    _profileSubscription = _profileRepository.watchProfile().listen(
      (user) {
        add(ProfileUpdateEvent(user: user));
      },
      onError: (error) {
        add(
          ProfileWatchErrorEvent(
            error: ProfileExceptionMapper.fromException(error),
          ),
        );
      },
    );
  }

  /// Обновляет состояние профиля.
  Future<void> _updateProfile(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSuccessState(user: event.user));
  }

  /// Останавливает отслеживание профиля.
  Future<void> _stopWatchProfile(
    ProfileStopWatchEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _profileSubscription?.cancel();
    _profileSubscription = null;
  }

  /// Обрабатывает ошибку при отслеживании.
  void _watchErrorProfile(
    ProfileWatchErrorEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileErrorState(message: event.error.message));
  }

  // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
  // Future<void> _onPickAvatar(
  //     ProfileAvatarChangedEvent event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   final currentState = state;
  //   if (currentState is! ProfileSuccessState) return;
  //
  //   emit(ProfileSavingState(user: currentState.user));
  //
  //   try {
  //     await _profileRepository.uploadAvatar(event.file);
  //   } on ProfileImageCanceledException {
  //     return;
  //   } on AppException catch (error) {
  //     emit(ProfileErrorState(message: error.message));
  //   }
  // }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
