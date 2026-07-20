import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/error/app_exception.dart';

part 'family_event.dart';

part 'family_state.dart';

/// Блок управлением состоянием экрана семьи
final class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc({required IFamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(const FamilyState()) {
    on<FamilyCreateEvent>(_createFamily);
  }

  /// Репозиторий семьи
  final IFamilyRepository _familyRepository;

  /// Подписка на прослушивание состояния семьи
  StreamSubscription<ProfileUserEntity?>? _familySubscription;

  Future<void> _createFamily(
    FamilyCreateEvent event,
    Emitter<FamilyState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _familyRepository.createFamily(name: event.name);

      emit(state.copyWith(isLoading: false, isCreated: true));
    } on AppException catch (error) {
      emit(state.copyWith(isLoading: false, error: error.message));
    }
  }

  @override
  Future<void> close() {
    _familySubscription?.cancel();
    return super.close();
  }
}
