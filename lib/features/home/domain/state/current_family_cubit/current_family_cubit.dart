import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/services/family/i_current_family_provider.dart';

final class CurrentFamilyCubit extends Cubit<String?> {
  CurrentFamilyCubit({required ICurrentFamilyProvider provider})
      : _provider = provider,
        super(null) {
    _subscription = _provider.watchCurrentFamilyId().listen(emit);
  }

  final ICurrentFamilyProvider _provider;

  late final StreamSubscription _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}