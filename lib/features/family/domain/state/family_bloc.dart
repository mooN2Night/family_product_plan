import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/entity/family_entity.dart';
import 'package:family_product_plan/features/family/domain/entity/family_member_info_entity.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/error/app_exception.dart';
import '../../data/mapper/family_exception_mapper.dart';

part 'family_event.dart';

part 'family_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyInitialState()) {
    on<FamilyCreateEvent>(_createFamily);
    on<FamilyWatchEvent>(_watchFamily);
    on<FamilyStopWatchEvent>(_stopWatchFamily);
    on<FamilyUpdateEvent>(_updateFamily);
    on<FamilyWatchErrorEvent>(_watchErrorFamily);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Подписка на прослушивание состояния семьи
  StreamSubscription<FamilyEntity?>? _familySubscription;

  /// Метод для создания семьи.
  Future<void> _createFamily(
    FamilyCreateEvent event,
    Emitter<FamilyState> emit,
  ) async {
    emit(const FamilyCreatingState());

    try {
      final familyId = await _familyRepository.createFamily(name: event.name);

      emit(FamilyCreatedState(familyId: familyId));
    } on AppException catch (error, stackTrace) {
      emit(FamilyErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  /// Метод для отслеживания обновления статуса семьи.
  Future<void> _watchFamily(
    FamilyWatchEvent event,
    Emitter<FamilyState> emit,
  ) async {
    emit(const FamilyLoadingState());

    await _familySubscription?.cancel();

    _familySubscription = _familyRepository
        .watchFamily(familyId: event.familyId)
        .listen(
          (family) {
            add(FamilyUpdateEvent(family: family));
          },
          onError: (error) {
            add(
              FamilyWatchErrorEvent(
                error: FamilyExceptionMapper.fromException(error),
              ),
            );
          },
        );
  }

  /// Метод для остановки отслеживания статуса семьи.
  Future<void> _stopWatchFamily(
    FamilyStopWatchEvent event,
    Emitter<FamilyState> emit,
  ) async {
    await _familySubscription?.cancel();
    _familySubscription = null;
  }

  /// Метод для обновления статуса участника в семье.
  Future<void> _updateFamily(
    FamilyUpdateEvent event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      final members = await _familyRepository.getFamilyMembersInfo(
        family: event.family,
      );

      emit(FamilyLoadedState(family: event.family, members: members));
    } on AppException catch (error, stackTrace) {
      emit(FamilyErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  /// Метод для получения ошибки в отслеживании статуса семьи.
  void _watchErrorFamily(
    FamilyWatchErrorEvent event,
    Emitter<FamilyState> emit,
  ) {
    emit(FamilyErrorState(message: event.error.message));
  }

  @override
  Future<void> close() {
    _familySubscription?.cancel();
    return super.close();
  }
}
